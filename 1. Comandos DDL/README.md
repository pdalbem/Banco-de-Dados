# Data Definition Language (DDL)
O DDL (Data Definition Language), ou Linguagem de Definição de Dados, é um conjunto de comandos SQL usados para definir, modificar e excluir estruturas de banco de dados, como tabelas, esquemas, índices, entre outros objetos. Permite também que se definam o domínio dos valores
associados a cada atributo (<a href="https://www.postgresql.org/docs/current/datatype.html" target="_blank">**tipos de dados**</a>) , bem como as regras de integridade.

## Comando CREATE
O comando CREATE é usado para criar novos objetos de banco de dados, como tabelas, índices, visões e procedimentos armazenados.

O comando **CREATE DATABASE** é usado para criar um novo banco de dados no PostgreSQL. Quando você executa esse comando, um novo banco de dados vazio é criado, e você pode começar a definir suas tabelas, esquemas e outras estruturas de dados dentro dele.
Sintaxe básica:
```sql
CREATE DATABASE nome_do_banco;
```
Exemplo:
```sql
CREATE DATABASE loja;
```

O comando **CREATE TABLE** é utilizado para criar uma nova tabela dentro de um banco de dados. A sintaxe básica para criar uma tabela envolve a definição do nome da tabela, seguida de uma lista de colunas com seus respectivos tipos de dados.

Aqui está um exemplo básico de como usar o comando CREATE TABLE:

```sql
CREATE TABLE nome_da_tabela (
    coluna1 tipo_de_dado CONSTRAINTS,
    coluna2 tipo_de_dado CONSTRAINTS,
    coluna3 tipo_de_dado CONSTRAINTS,
    ...
);
```
sendo que

* nome_da_tabela: O nome da nova tabela a ser criada.
* coluna: O nome da coluna dentro da tabela.
* tipo_de_dado: O tipo de dado da coluna (por exemplo, INTEGER, VARCHAR, DATE, etc.).
* CONSTRAINTS: Restrições (opcionais) que podem ser aplicadas às colunas, como NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, entre outras.

Exemplo de criação da tabela clientes sem usar restrições:

```sql
CREATE TABLE clientes (
    id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_nascimento DATE
);
```
## Restrições
As restrições (constraints) no PostgreSQL são regras aplicadas às colunas de uma tabela para garantir a integridade e a consistência dos dados. Elas podem ser definidas no momento da criação da tabela ou alteradas posteriormente.

Aqui estão as principais restrições que podem ser aplicadas em tabelas no PostgreSQL:

**1. PRIMARY KEY**
Restrição usada para garantir que os valores em uma coluna (ou conjunto de colunas) sejam únicos e não nulos. Cada tabela pode ter no máximo uma chave primária. A chave primária serve para identificar de forma única cada linha em uma tabela. É implicitamente criada uma restrição NOT NULL nas colunas da chave primária.
Exemplo:
```sql
CREATE TABLE clientes (
    id INT,
    nome VARCHAR(100),
    CONSTRAINT pk_clientes PRIMARY KEY (id)
);
```

Alternativamente, podemos definir restrição de chave primária sem fornecer um nome para a restrição. Omitindo o
nome da restrição, o Postregsql irá dar o nome padrão _nometabela_pkey_
```sql
CREATE TABLE clientes (
    id INT,
    nome VARCHAR(100),
    PRIMARY KEY (id)
);
```

Se a chave primária da tabela for um campo único, é possível definir a restrição imediatamente após a especificação do campo:
```sql
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100)
);
```

O exemplo acima não funciona quando a tabela possui chave primária composta, devendo-se recorrer às alternativas anteriores, como por exemplo:
```sql
CREATE TABLE itens_pedido (
    id_Pedido INT,
    id_Produto INT,
    quantidade INT,
    PRIMARY KEY (id_Pedido, id_Produto)
);
```



**2. FOREIGN KEY**
Restrição usada para estabelecer uma relação entre duas tabelas. Ela garante que os valores de uma coluna (ou conjunto de colunas) correspondam aos valores da chave primária ou de uma chave única em outra tabela.
Exemplo:
```sql
CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

**3. UNIQUE**
Restrição garante que os valores em uma coluna (ou conjunto de colunas) sejam únicos. Isso significa que nenhuma linha pode ter o mesmo valor em uma coluna com essa restrição. Ao contrário da chave primária, a coluna com restrição UNIQUE pode aceitar valores nulos (embora o PostgreSQL trate múltiplos valores nulos como "diferentes").
Exemplo:
```sql
CREATE TABLE usuarios (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
```

**4. NOT NULL**
A restrição NOT NULL assegura que uma coluna não possa ter valores nulos. Isso é útil para garantir que uma determinada coluna sempre tenha um valor válido.

Exemplo:
```sql
CREATE TABLE funcionarios (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL NOT NULL
);
```

**5. CHECK**
A restrição CHECK permite definir uma condição que os valores em uma coluna devem atender. A condição pode ser qualquer expressão booleana válida.

Exemplo:
```sql
CREATE TABLE produtos (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL CHECK (preco >= 0)
);
```

**6. DEFAULT**
A restrição DEFAULT não é uma restrição de integridade, mas um valor padrão atribuído a uma coluna quando nenhum valor é fornecido. Pode ser útil para colunas que geralmente recebem um valor fixo se nenhum dado for fornecido.

Exemplo:
```sql
CREATE TABLE vendas (
    id INT PRIMARY KEY,
    produto VARCHAR(100),
    quantidade INT DEFAULT 1
);
```

Exemplos de uso combinado de restrições
É possível combinar várias restrições em uma tabela. Por exemplo, ao criar uma tabela de clientes, você pode usar várias restrições para garantir a integridade dos dados:
```sql
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(15),
    data_nascimento DATE CHECK (data_nascimento <= CURRENT_DATE - INTERVAL '18 years')
);
```

## Comando ALTER 
O comando ALTER é utilizado para modificar a estrutura de um objeto existente no banco de dados, como adicionar ou remover colunas, alterar restrições ou renomear objetos.

### Adicionar uma coluna: 
```sql
ALTER TABLE nome_da_tabela ADD COLUMN nova_coluna tipo_de_dado;
```

Exemplo:
```sql
ALTER TABLE clientes ADD COLUMN telefone VARCHAR(15);
```
### Remover uma coluna:
```sql
ALTER TABLE nome_da_tabela DROP COLUMN nome_da_coluna;
```

Exemplo:
```sql
ALTER TABLE clientes DROP COLUMN telefone;
```

### Renomear uma coluna:
```sql
ALTER TABLE nome_da_tabela RENAME COLUMN nome_antigo TO nome_novo;
```

Exemplo:
```sql
ALTER TABLE clientes RENAME COLUMN email TO email_cliente;
```

### Renomear uma tabela:
```sql
ALTER TABLE nome_antigo RENAME TO nome_novo;
```

Exemplo:
```sql
ALTER TABLE clientes RENAME TO consumidores;
```

### Renomear um banco de dados:
```sql
ALTER DATABASE nome_antigo RENAME TO nome_novo;
```

Exemplo:
```sql
ALTER DATABASE loja RENAME TO empresa;
```

### Alterar o tipo de dado de uma coluna:
```sql
ALTER TABLE nome_da_tabela ALTER COLUMN nome_da_coluna TYPE novo_tipo;
```

Exemplo:
```sql
ALTER TABLE clientes ALTER COLUMN data_nascimento TYPE TEXT;
```

### Alterar uma tabela para adicionar ou remover constraints (restrições):
A sintaxe para **adicionar** constraints é:
```sql
ALTER TABLE nome_da_tabela ADD CONSTRAINT nome_constraint constraint_desejada;
```

Exemplos:
```sql
ALTER TABLE empregado ADD CONSTRAINT pk_empregado PRIMARY KEY (codempregado); 
```

```sql
ALTER TABLE empregado ADD CONSTRAINT 
fk_emp_dep FOREIGN KEY (depto_num) 
REFERENCES departamento(numero);
```

```sql
ALTER TABLE pedidos ADD CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id);
```

```sql
ALTER TABLE aluno ADD CONSTRAINT email_unique UNIQUE(email);
```

```sql
ALTER TABLE produto ADD CONSTRAINT preco_chk CHECK(preco > 0);
```

Para o NOT NULL é um pouco diferentes:
```sql
ALTER TABLE aluno ALTER telefone SET NOT NULL;
```

A sintaxe para **remover** uma constraint é:
```sql
ALTER TABLE nome_da_tabela DROP CONSTRAINT nome_constraint;
```

Exemplos:
```sql
ALTER TABLE empregado DROP CONSTRAINT fk_emp_dep; 
```

```sql
ALTER TABLE empregado DROP CONSTRAINT pk_empregado; 
```

```sql
ALTER TABLE pedidos DROP CONSTRAINT fk_cliente;
```
```sql
ALTER TABLE aluno ALTER telefone DROP NOT NULL;
```


## Comando DROP 
O comando DROP é utilizado para excluir permanentemente objetos do banco de dados. Pode ser usado para remover tabelas, esquemas e bancos de dados inteiros.

```sql
DROP TABLE nome_da_tabela;
```

Exemplo:
```sql
DROP TABLE clientes;
```
Se a tabela contiver dados, ela será excluída junto com todos os dados armazenados nela.

```sql
DROP DATABASE nome_do_banco;
```

Exemplo:
```sql
DROP DATABASE empresa;
```
Se o banco de dados contiver tabelas e dados, todos serão excluídos permanentemente.