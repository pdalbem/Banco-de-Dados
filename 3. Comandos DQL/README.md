# Data Query Language (DQL)
DQL (Data Query Language) é um subconjunto da linguagem SQL usado para consultar e recuperar dados armazenados em bancos de dados relacionais. O objetivo da DQL é buscar dados que já estão armazenados, sem modificá-los.

O principal comando DQL é o **SELECT**, que frequentemente pode ser usado com outras cláusulas e operadores que refinam e especificam como os dados devem ser consultados e apresentados.


A seguir, veremos os principais comandos DQL no PostgreSQL. Para tanto, considere a existência do banco de dados com as tabelas:

```sql
CREATE TABLE cidade
(
codcid int PRIMARY KEY,
nome varchar(40) NOT NULL,
uf char(2) NOT NULL
);

CREATE TABLE aluno
(
codalu int PRIMARY KEY,
cpf char(11) NOT NULL UNIQUE,
nome varchar(40) NOT NULL,
telefone varchar(20),
cidade int,
CONSTRAINT fk_cidade FOREIGN KEY (cidade) REFERENCES cidade(codcid)
on update cascade on delete set null
);

CREATE TABLE categoria
(
codcat int PRIMARY KEY,
descricao varchar(20) NOT NULL
);

CREATE TABLE curso
(
codcur int PRIMARY KEY,
nome varchar(30) NOT NULL,
cargahoraria int CHECK (cargahoraria > 0),
preco real,
categoria int,
FOREIGN KEY(categoria) REFERENCES categoria(codcat)
on update cascade on delete set null
);

CREATE TABLE matricula
(
  codalu int,
  codcur int,
  nota real CHECK (nota>=0 and nota <=10),
  datacurso date,	
  PRIMARY KEY (codalu,codcur,datacurso),
  CONSTRAINT fk_aluno FOREIGN KEY (codalu) REFERENCES aluno(codalu) on update cascade,
  CONSTRAINT fk_curso FOREIGN KEY (codcur) REFERENCES curso(codcur) on update cascade
);
```
Com estes registros:
**Cidade**

| codcid | nome         | uf |
|--------|--------------|----|
| 1      | São Carlos   | SP |
| 2      | Araraquara   | SP |
| 3      | Londrina     | PR |
| 4      | Rio de Janeiro | RJ |
| 5      | Curitiba     | PR |
| 6      | Rio Claro    | SP |
| 7      | Belo Horizonte | MG |

**Aluno**

| codalu | cpf           | nome     | telefone    | cidade |
|--------|---------------|----------|-------------|--------|
| 1      | 11111111111   | Maria    | 9999-9999   | 1      |
| 2      | 22222222222   | Celso    | 8888-8888   | 1      |
| 3      | 33333333333   | Joaquim  | 7777-7777   | 2      |
| 4      | 44444444444   | Florinda | 6666-6666   | 3      |
| 5      | 55555555555   | Manoel   | (null)      | 3      |

**Categoria**

| codcat | descricao      |
|--------|----------------|
| 1      | Programação    |
| 2      | Banco de Dados |
| 3      | Machine Learning |
| 4      | Redes          |

**Curso**

| codcur | nome          | cargahoraria | preco   | categoria |
|--------|---------------|--------------|---------|-----------|
| 1      | Java          | 30           | 1400.00 | 1         |
| 2      | PostgreSQL    | 30           | 600.00  | 2         |
| 3      | Deep Learning | 20           | 1000.00 | 3         |
| 4      | Python        | 20           | 500.00  | 1         |
| 5      | MySQL         | 30           | 500.00  | 2         |

**Matricula**

| codalu | codcur | nota | datacarso  |
|--------|--------|------|------------|
| 1      | 1      | 9.5  | 2024-02-14 |
| 1      | 2      | 10.0 | 2024-03-01 |
| 2      | 4      | 8.5  | 2023-12-10 |
| 4      | 2      | 9.0  | 2024-04-01 |
| 2      | 4      | 9.0  | 2024-04-10 |

## Comando SELECT
O comando SELECT é a base do DQL (Data Query Language) e permite que você especifique quais colunas deseja visualizar de uma ou mais tabelas.

Sintaxe básica para recuperar dados de uma única tabela:
```sql
SELECT coluna1, coluna2,...,colunaN
FROM tabela
[WHERE condição]
[GROUP BY colunas]
[HAVING condição]
[ORDER BY colunas];
 ```

### Selecionando colunas básicas
A forma mais simples do SELECT é escolher as colunas que você quer ver de uma tabela:
```sql
SELECT nome, telefone
FROM aluno;
```
| nome     | telefone   |
|----------|------------|
| Maria    | 9999-9999  |
| Celso    | 8888-8888  |
| Joaquim  | 7777-7777  |
| Florinda | 6666-6666  |
| Manoel   | (null)     |


### Retornando todas as colunas
Pode-se usar o * (asterisco) no SELECT como forma de recuperar todas as colunas de uma tabela, sem precisar especificar individualmente os nomes das colunas.
```sql
SELECT *
FROM aluno;
```
Esse comando traz todas as colunas e todas as linhas da tabela aluno.
| codalu | cpf           | nome     | telefone    | cidade |
|--------|---------------|----------|-------------|--------|
| 1      | 11111111111   | Maria    | 9999-9999   | 1      |
| 2      | 22222222222   | Celso    | 8888-8888   | 1      |
| 3      | 33333333333   | Joaquim  | 7777-7777   | 2      |
| 4      | 44444444444   | Florinda | 6666-6666   | 3      |
| 5      | 55555555555   | Manoel   | (null)      | 3      |

### ALIAS
O ALIAS permite renomear temporariamente colunas ou tabelas na saída da sua consulta, tornando os resultados mais legíveis.
Alias da coluna:
```sql
SELECT nome AS nome_do_aluno, telefone AS contato
FROM aluno;
```
| nome_do_aluno | contato   |
|---------------|-----------|
| Maria         | 9999-9999 |
| Celso         | 8888-8888 |
| Joaquim       | 7777-7777 |
| Florinda      | 6666-6666 |
| Manoel        | (null)    |

Alias da coluna (útil em join - veremos mais adiante):
```sql
SELECT a.nome AS nome_aluno, c.nome AS nome_cidade
FROM aluno AS a
JOIN cidade AS c ON a.cidade = c.codcid;
```

### Cláusula WHERE - Filtrando resultados
A cláusula WHERE em SQL é uma ferramenta poderosa para filtrar registros em uma tabela. Ela permite especificar condições que as linhas devem atender para serem incluídas nos resultados de uma consulta SELECT.

A cláusula WHERE pode usar vários operadores para especificar condições, incluindo:

* Operadores de comparação: =, !=, >, <, >=, <=.    
* Operadores lógicos: AND, OR, NOT.
* Operador LIKE: para pesquisa de padrões de texto.
* Operador IN: para verificar se um valor está em uma lista.
* Operador BETWEEN: para verificar se um valor está dentro de um intervalo.
* Operador IS NULL: para verificar valores nulos.

Exemplo do operador de comparação **=**:
```sql
SELECT nome, uf
FROM cidade
WHERE uf = 'SP';
```
**Resultado:**
| nome        | uf |
|-------------|----|
| São Carlos  | SP |
| Araraquara  | SP |
| Rio Claro   | SP |

Exemplo do operador lógico **AND**:
```sql
SELECT nome FROM curso
WHERE preco > 500 AND cargahoraria >= 30;
```
**Resultado:**
| nome     |
|----------|
| Java     |
| PostgreSQL |

Exemplo do operador lógico **OR**:
```sql
SELECT nome FROM aluno
WHERE cidade = 1 OR cidade = 2;
```
**Resultado:**
| nome    |
|---------|
| Maria   |
| Celso   |
| Joaquim |

Exemplo do operador **IS NULL**:
```sql
SELECT nome FROM aluno
WHERE telefone IS NULL;
```
**Resultado:**
| nome   |
|--------|
| Manoel |

Exemplo do operador **BETWEEN**:
```sql
SELECT nome, preco FROM curso
WHERE preco BETWEEN 500 AND 1000;
```
**Resultado:**
| nome       | preco  |
|------------|--------|
| Java       | 1400.0 |
| PostgreSQL | 600.0  |
| Deep Learning | 1000.0 |

Exemplo do operador **LIKE**:
```sql
SELECT nome FROM aluno
WHERE nome LIKE 'M%'; -- nomes que começam com 'M'
```
**Resultado:**
| nome  |
|-------|
| Maria |
| Manoel|

Exemplo do operador  **IN**:
```sql
SELECT nome FROM cidade
WHERE uf IN ('SP', 'MG');
```
**Resultado:**
| nome           | uf |
|----------------|----|
| São Carlos     | SP |
| Araraquara     | SP |
| Rio Claro      | SP |
| Belo Horizonte | MG |



### DISTINCT
A cláusula DISTINCT retorna apenas valores únicos em uma ou mais colunas selecionadas.
```sql
SELECT DISTINCT uf
FROM cidade;
```
**Resultado:**
| uf |
|----|
| SP |
| PR |
| RJ |
| MG |

```sql
SELECT DISTINCT cidade
FROM aluno;
```
**Resultado:**
| cidade |
|--------|
| 1      |
| 2      |
| 3      |


### LIMIT
A cláusula LIMIT em PostgreSQL restringe a quantidade de linhas retornadas por uma consulta SELECT.
```sql
-- Mostra os 5 primeiros alunos
SELECT * FROM aluno
LIMIT 5;
```
**Resultado:**
| codalu | cpf           | nome     | telefone    | cidade |
|--------|---------------|----------|-------------|--------|
| 1      | 11111111111   | Maria    | 9999-9999   | 1      |
| 2      | 22222222222   | Celso    | 8888-8888   | 1      |
| 3      | 33333333333   | Joaquim  | 7777-7777   | 2      |
| 4      | 44444444444   | Florinda | 6666-6666   | 3      |
| 5      | 55555555555   | Manoel   | (null)      | 3      |


```sql
-- Lista os 3 cursos mais baratos
SELECT nome, preco
FROM curso
ORDER BY preco ASC
LIMIT 3;
```
**Resultado:**

| nome     | preco |
|----------|-------|
| Python   | 500.0 |
| MySQL    | 500.0 |
| PostgreSQL | 600.0 |

Você também pode usar OFFSET junto com LIMIT para pular linhas. Isso é útil, por exemplo, em paginação de resultados.
```sql
-- Pula os 5 primeiros cursos e mostra os 5 seguintes
SELECT nome, preco
FROM curso
ORDER BY preco
LIMIT 5 OFFSET 5;
```
Nesse exemplo:

OFFSET 5: pula os 5 primeiros registros.

LIMIT 5: mostra os 5 próximos.


### ORDER BY: Ordenando os Resultados
A cláusula ORDER BY permite especificar a ordem em que as linhas do resultado serão exibidas. Por padrão, a ordenação é ascendente (ASC). Para ordenar de forma descendente, usamos DESC.
```sql
SELECT nome, preco
FROM curso
ORDER BY preco DESC; -- Cursos listados do mais caro para o mais barato
```
**Resultado:**
| nome          | preco  |
|---------------|--------|
| Java          | 1400.0 |
| Deep Learning | 1000.0 |
| PostgreSQL    | 600.0  |
| Python        | 500.0  |
| MySQL         | 500.0  |

```sql
SELECT uf, nome
FROM cidade
ORDER BY uf ASC, nome DESC; -- Cidades ordenadas por UF (ascendente) e, dentro de cada UF, por nome (descendente)
```
**Resultado:**
| uf | nome           |
|----|----------------|
| MG | Belo Horizonte |
| PR | Curitiba       |
| PR | Londrina       |
| RJ | Rio de Janeiro |
| SP | Araraquara     |
| SP | Rio Claro      |
| SP | São Carlos     |

### Funções de Agregação: Calculando Resumos
As funções de agregação realizam cálculos em um conjunto de valores e retornam um único valor resumido. As mais comuns são:

* COUNT(): Conta o número de linhas.
* SUM(): Soma os valores de uma coluna numérica.
* AVG(): Calcula a média dos valores de uma coluna numérica.
* MAX(): Retorna o valor máximo de uma coluna.
* MIN(): Retorna o valor mínimo de uma coluna.

Exemplo com **COUNT**:
```sql
SELECT COUNT(*) AS total_alunos
FROM aluno; -- Conta o número total de alunos
```
**Resultado:**
| total_alunos |
|--------------|
| 5            |

Exemplo com **AVG**:
```sql
SELECT AVG(preco) AS preco_medio_cursos_programacao
FROM curso
WHERE categoria = 1; -- Calcula o preço médio dos cursos de programação
```
**Resultado:**
| preco_medio_cursos_programacao |
|--------------------------------|
| 950.0                          |

Exemplo com **MAX**:
```sql
SELECT MAX(nota) AS nota_maxima
FROM matricula; -- Encontra a maior nota registrada
```
**Resultado:**
| nota_maxima |
|-------------|
| 10.0        |

### GROUP BY: Agrupando Resultados
A cláusula GROUP BY agrupa linhas que têm os mesmos valores em uma ou mais colunas especificadas. É frequentemente usada em conjunto com funções de agregação para realizar cálculos por grupo.
```sql
SELECT c.descricao AS categoria_curso, COUNT(cu.codcur) AS numero_cursos
FROM categoria AS c
JOIN curso AS cu ON c.codcat = cu.categoria
GROUP BY c.descricao; -- Conta o número de cursos por categoria
```
Esta consulta agrupa os cursos pela sua categoria e conta quantos cursos existem em cada categoria.
| categoria_curso | numero_cursos |
|-----------------|---------------|
| Programação     | 2             |
| Banco de Dados  | 2             |
| Machine Learning| 1             |


### HAVING: Filtrando Grupos
A cláusula HAVING é usada para filtrar os resultados de grupos criados pela cláusula GROUP BY. Ela funciona de forma semelhante ao WHERE, mas opera em grupos, não em linhas individuais
```sql
SELECT c.descricao AS categoria_curso, AVG(cu.preco) AS preco_medio
FROM categoria AS c
JOIN curso AS cu ON c.codcat = cu.categoria
GROUP BY c.descricao
HAVING AVG(cu.preco) > 700; -- Mostra apenas as categorias onde o preço médio dos cursos é maior que 700
```
Esta consulta primeiro agrupa os cursos por categoria e calcula o preço médio para cada categoria. Em seguida, ela filtra e exibe apenas as categorias cujo preço médio é superior a 700.
| categoria_curso | preco_medio |
|-----------------|-------------|
| Programação     | 950.0       |
| Machine Learning| 1000.0      |

```sql
SELECT cidade, COUNT(*) AS total
FROM aluno
GROUP BY cidade
HAVING COUNT(*) > 1;
```
Essa consulta retorna os códigos das cidades que têm mais de um aluno cadastrado na tabela aluno.
SELECT cidade, COUNT(*) AS total
FROM aluno
GROUP BY cidade
HAVING COUNT(*) > 1;

**Não confunda WHERE com HAVING**. Use WHERE para filtrar linhas individuais antes do agrupamento, e HAVING para filtrar grupos depois do GROUP BY.
```sql
-- WHERE: alunos com cidade diferente de nulo (linha por linha)
SELECT cidade, COUNT(*) 
FROM aluno
WHERE cidade IS NOT NULL
GROUP BY cidade;
```
**Resultado:**
| cidade | count |
|--------|-------|
| 1      | 2     |
| 2      | 1     |
| 3      | 2     |

```sql
-- HAVING: só cidades com mais de 1 aluno (filtra os grupos)
SELECT cidade, COUNT(*) 
FROM aluno
GROUP BY cidade
HAVING COUNT(*) > 1;
```
**Resultado:**
| cidade | count |
|--------|-------|
| 1      | 2     |
| 3      | 2     |

