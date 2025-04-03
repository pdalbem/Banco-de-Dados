# Data Manipulation Language (DML)
Os comandos DML (Data Manipulation Language) no PostgreSQL são utilizados para manipular os dados dentro das tabelas. Eles incluem operações como inserção, atualização e exclusão dados.


A seguir, veremos os principais comandos DML no PostgreSQL. Para tanto, considere a existência da tabela clientes:
```sql
CREATE TABLE clientes
(
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(50) DEFAULT 'Não informado' 
);
```

## Comando INSERT
O comando INSERT adiciona novas linhas a uma tabela.
Sintaxe básica:
```sql
INSERT INTO nome_da_tabela (coluna1, coluna2, ...) VALUES (valor1, valor2, ...);
```
sendo que:
* **INSERT INTO**: Inicia o comando de inserção.
* **nome_da_tabela**: Especifica a tabela onde os dados serão inseridos.
* **(coluna1, coluna2, ..., colunaN)**: Lista as colunas nas quais os valores serão inseridos. Essa parte é opcional; se omitida, os valores serão atribuídos na ordem das colunas da tabela.
* **VALUES (valor1, valor2, ..., valorN)**: Fornece os valores a serem inseridos nas respectivas colunas.

Exemplos:
### Inserindo um registro completo
```sql
INSERT INTO clientes (id, nome, email) VALUES (1,'Maria', 'maria@email.com');
```

Já que eu quero inserir valores para todas as colunas, posso omitir a lista de colunas que serão preenchidas. 
```sql
INSERT INTO clientes VALUES (2,'Clara', 'clara@email.com');
```
Desta forma, o PostgreSQL entende que todas as colunas serão preenchidas. Devo passar, então, os valores para estas colunas na ordem que elas foram criadas pelo **CREATE TABLE**

### Inserindo registros com colunas específicas
Considere que por algum motivo, eu não quero preencher o campo email. Portanto, especifico que os únicos campos a receberem valor serão id e nome:
```sql
INSERT INTO clientes (id, nome) VALUES (3,'Celso');
```
Neste exemplo, a coluna email receberá o valor ```'Não informado'```, conforme especificado pela restrição (__constraint__) **DEFAULT** na criação da tabela. Se o campo email não tivesse a restrição DEFAULT, ele receberia NULL neste caso.

O seguinte comando geraria **erro**, pois está se tentando inserir um registro sem fornecer o nome do cliente. Porém o campo nome possui a restrição NOT NULL.
```sql
INSERT INTO clientes (id, email) VALUES (3,'celso@email.com');
```

O próximo comando também geraria **erro**, Ao omitir a lista de colunas, o PostgreSQL assume que você deseja inserir valores em todas as colunas da tabela clientes (id, nome, email). Porém, como você forneceu apenas dois valores, a inserção falha.
```sql
INSERT INTO clientes VALUES (3,'Celso');
```



### Inserindo vários registros ao mesmo tempo
Também é possível inserir vários registros de uma só vez:
```sql
INSERT INTO clientes (id, nome, email)  
VALUES 
  (4,'Joaquim Souza', 'joaquim@email.com'),  
  (5,'Carlos Lima', 'carlos@email.com');
```

## Comando UPDATE 
O UPDATE modifica os valores de registros existentes.
Sintaxe:

```sql
UPDATE nome_da_tabela 
SET coluna1 = valor1, coluna2 = valor2, ... 
WHERE condição;
```

Exemplos:
### Atualizando um único campo
```sql
UPDATE clientes 
SET email = 'mariasilva@email.com' 
WHERE id = 1;
```
### Atualizando mais de um campo ao mesmo tempo:
```sql
UPDATE clientes 
SET nome='Maria Silva', email = 'maria_silva@email.com' 
WHERE id = 1;
```

**CUIDADO:** Se não houver a cláusula **WHERE**, todos os registros da tabela serão atualizados.

## Comando DELETE 
O DELETE remove registros de uma tabela.
Sintaxe:
```sql
DELETE FROM nome_da_tabela WHERE condição;
```

Exemplo:
```sql
DELETE FROM clientes WHERE nome = 'Maria Silva';
```
**CUIDADO:** Se não houver a cláusula **WHERE**, todos os registros da tabela serão apagados.

## Cláusula WHERE
A cláusula WHERE em SQL é uma ferramenta poderosa para filtrar registros em uma tabela. Ela permite especificar condições que as linhas devem atender para serem incluídas nos resultados de uma consulta SELECT, atualizadas por um comando UPDATE ou excluídas por um comando DELETE.

A cláusula WHERE pode usar vários operadores para especificar condições, incluindo:

* Operadores de comparação: =, !=, >, <, >=, <=.    
* Operadores lógicos: AND, OR, NOT.
* Operador LIKE: para pesquisa de padrões de texto.
* Operador IN: para verificar se um valor está em uma lista.
* Operador BETWEEN: para verificar se um valor está dentro de um intervalo.
* Operador IS NULL: para verificar valores nulos.

## Violação de Integridade Referencial
A violação de integridade referencial ocorre quando uma restrição de chave estrangeira (__FOREIGN KEY__) é quebrada devido a uma operação ```INSERT```, ```UPDATE``` ou ```DELETE``` que não mantém a relação esperada entre tabelas.


### Principais causas da violação de integridade referencial
Veremos a seguir as principais causas de violação da integridade referencial:
1) Inserção de um valor inexistente (INSERT)
2) Atualização de um valor inexistente (UPDATE)
3) Exclusão de um valor inexistente (DELETE)

Para tanto, considere as tabelas clientes e pedidos:
```sql
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id)
);
```

**1) Inserção de um valor inexistente (INSERT)**

Se tentarmos inserir um registro em uma tabela filha referenciando um ID que não existe na tabela pai, ocorre uma violação.

Exemplo: Inserindo um pedido para um cliente que não existe
```sql
INSERT INTO pedidos (id, cliente_id) VALUES (1, 999);
```
Isso resultará no erro:
```sql
ERROR: insert or update on table "pedidos" violates foreign key constraint "pedidos_cliente_id_fkey"
DETAIL: Key (cliente_id)=(999) is not present in table "clientes".
```

**2) Atualização de um valor referenciado (UPDATE)**

Se uma chave primária na tabela pai for alterada sem propagar a mudança na tabela filha, a referência se tornará inválida.

```sql
UPDATE clientes SET id = 10 WHERE id = 1;
```
Se já existirem pedidos referenciando cliente_id = 1, ocorre um erro:
```sql
ERROR: update or delete on table "clientes" violates foreign key constraint "pedidos_cliente_id_fkey" on table "pedidos"
DETAIL: Key (id)=(1) is still referenced from table "pedidos".
```

**3) Exclusão de um valor referenciado (DELETE)**
Se tentarmos excluir um registro da tabela pai que ainda é referenciado na tabela filha, ocorre uma violação.

```sql
DELETE FROM clientes WHERE id = 1;
```
Se já existirem pedidos referenciando cliente_id = 1, ocorre um erro:
```sql
ERROR: update or delete on table "clientes" violates foreign key constraint "pedidos_cliente_id_fkey" on table "pedidos"
DETAIL: Key (id)=(1) is still referenced from table "pedidos".
```

### Tratamento adequado para violação de integridade referencial
A solução para não ocorrer violação de integridade referencial quando ocorrer a inserção de um valor inexistente (causa nro. 1), é 
inserir primeiramente o cliente correspondente na tabela clientes.

Já para as causas de atualização e exclusão de valor referenciado, podemos tratar adequadamente por meio das cláusulas **ON UPDATE** e **ON DELETE**.

### Cláusulas ON UPDATE e ON DELETE
Podemos definir algumas regras durante na restrição de chave estrangeira, a fim de evitar que ocorra violação de integridade referencial. Estas regras vão estabelecer o que acontece nos registros da tabela filha quando o registro referenciado na tabela pai sofre uma atualização (UPDATE) ou uma exclusão (DELETE).

Essas regras são definidas pelas cláusulas ON UPDATE e ON DELETE e servem para evitar erros de integridade referencial. Opções disponíveis para estas cláusulas:

* **CASCADE**:	Propaga a ação para a tabela filha. Se o pai for atualizado ou deletado, a mudança ocorre na filha também.
* **SET NULL**:	Define NULL na chave estrangeira quando a linha pai é alterada ou removida.
* **SET DEFAULT**:	Define um valor padrão na chave estrangeira.

### Exemplos
**ON DELETE CASCADE** 

Se quisermos que, ao deletar um registro na tabela pai, todos os registros filhos associados também sejam removidos automaticamente, usamos ON DELETE CASCADE.

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT, 
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id) ON DELETE CASCADE
);
```
Agora, se um cliente for deletado, todos os seus pedidos também serão removidos. Isso evita que pedidos fiquem "órfãos" sem um cliente associado. Cuidado com esta cláusula, nem sempre o efeito desejado é este. 

**ON DELETE SET NULL** 

Se quisermos manter os pedidos, mas sem um cliente associado quando o cliente for excluído, podemos usar ON DELETE SET NULL:

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT, 
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id) ON DELETE SET NULL
);
```
Agora, ao deletar um cliente, os pedidos ainda existirão, mas o campo cliente_id será NULL.

**ON UPDATE CASCADE** 

Se um cliente tiver seu ID alterado e quisermos atualizar todos os pedidos automaticamente, usamos ON UPDATE CASCADE:

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT, 
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id) ON UPDATE CASCADE
);
```
Agora, ao alterar o id de um cliente, todos os registros da tabela pedidos cujo campo cliente_id referecia o cliente que sofreu a atualização, também serão atualizados.

**ON UPDATE SET NULL** 

Com esta cláusula, se um cliente tiver seu ID alterado, o campo cliente_id da tabela pedidos que o referenciava passará a valer NULL

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT, 
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id) ON UPDATE SET NULL
);
```

**On UPDATE e ON DELETE juntas**
É possível combinar as cláusulas também:
```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT, 
    CONSTRAINT fk_clientes FOREIGN KEY REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE SET NULL
);
```

### Alterando a restrição de FK de uma tabela existente
Caso a tabela já exista e queiramnos alterar sua restrição de chave estrangeira para contemplar as cláusulas ON UPDATE e ON DELETE, a fim de evitar violação de integridade referencial, devemos:

1) Primeiramente, apagar a restrição de chave estrangeira existente:
```sql
ALTER TABLE pedidos DROP CONSTRAINT fk_Clientes;
```

2) Em seguida, recriá-la com as regras desejadas:
```sql
ALTER TABLE pedidos 
ADD CONSTRAINT fk_clientes
FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE SET NULL;
```