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

## Junção de Tabelas
Até aqui, trabalhamos apenas com consultas envolvendo uma única tabela.
Agora, vamos aprender como consultar dados que estão distribuídos em múltiplas tabelas relacionadas.

O comando JOIN é fundamental em SQL para combinar linhas de duas ou mais tabelas com base em uma coluna relacionada entre elas. Isso permite que você consulte dados que estão distribuídos em diferentes tabelas, criando visões mais completas e informativas.

Existem diferentes tipos de JOINs, cada um com um comportamento específico em relação às linhas que são incluídas no resultado da consulta:

### INNER JOIN

INNER JOIN (ou simplesmente JOIN): Retorna apenas as linhas onde há uma correspondência nas colunas especificadas em ambas as tabelas. Linhas sem correspondência em alguma das tabelas são excluídas do resultado.

Exemplo 1: Mostrar todos os cursos com o nome de suas respectivas categorias
```sql
SELECT c.codcur, c.nome, c.cargahoraria, c.preco, cat.descricao 
FROM curso c INNER JOIN categoria cat
ON c.categoria=cat.codcat;
```

| codcur | nome          | cargahoraria | preco   | descricao       |
|--------|---------------|--------------|---------|-----------------|
| 1      | Java          | 30           | 400.00  | Programação     |
| 2      | PostgreSQL    | 30           | 600.00  | Banco de Dados  |
| 3      | Deep Learning | 20           | 1000.00 | Machine Learning|
| 4      | Python        | 20           | 500.00  | Programação     |
| 5      | MySQL         | 30           | 500.00  | Banco de Dados  |


Exemplo 2: Mostrar os dados dos alunos, com o nome e uf de suas respectivas cidades
```sql
SELECT a.codalu, a.cpf, a.nome, a.telefone, c.nome, c.uf
FROM aluno a INNER JOIN cidade c
ON a.cidade=c.codcid;  
```

| codalu | cpf           | nome      | telefone    | nome        | uf |
|--------|---------------|-----------|-------------|-------------|----|
| 1      | 11111111111   | Maria     | 9999-9999   | São Carlos  | SP |
| 2      | 22222222222   | Celso     | 8888-8888   | São Carlos  | SP |
| 3      | 33333333333   | Joaquim   | 7777-7777   | Araraquara  | SP |
| 4      | 44444444444   | Florinda  | 6666-6666   | Londrina    | PR |
| 5      | 55555555555   | Manoel    |             | Londrina    | PR |

Exemplo 3: Mostrar os dados das matrículas, com os nomes dos alunos e dos cursos
```sql
SELECT a.nome "Aluno", c.nome "Curso", m.nota "Nota", to_char(m.datacurso, 'dd-mm-yyyy') "Data" 
FROM aluno a INNER JOIN matricula m ON a.codalu=m.codalu
INNER JOIN curso c  ON c.codcur=m.codcur;
```
| Aluno   | Curso         | Nota | Data       |
|---------|---------------|------|------------|
| Maria   | Java          | 9.5  | 14-02-2024 |
| Maria   | PostgreSQL    | 10   | 01-03-2024 |
| Celso   | Python        | 8.5  | 10-12-2023 |
| Florinda| Python        | 9    | 01-04-2024 |
| Celso   | MySQL         | 9    | 10-04-2024 |


Exemplo 4: Mostrar os dados das matrículas, com os nomes dos alunos, nomes de suas respectivas cidades, nome dos cursos e suas respectivas categorias. Porém, mostre somente aquelas cujas notas sejam maior que 8 e a data do curso esteja entre 01/04/2024 e 30/04/2024 
```sql
SELECT a.nome "Aluno", ci.nome "Cidade",  c.nome "Curso", cat.descricao "Categoria", m.nota "Nota", to_char(m.datacurso, 'dd-mm-yyyy') "Data" 
FROM matricula m INNER JOIN aluno a ON m.codalu=a.codalu
INNER JOIN cidade ci ON ci.codcid=a.cidade
INNER JOIN curso c ON c.codcur=m.codcur
INNER JOIN categoria cat ON cat.codcat=c.categoria
WHERE m.nota>8 AND m.datacurso BETWEEN '2024-04-01' AND '2024-04-30';
```
| Aluno    | Cidade   | Curso   | Categoria     | Nota | Data       |
|----------|----------|---------|---------------|------|------------|
| Florinda | Londrina | Python  | Programação   | 9    | 01-04-2024 |
| Celso    | São Carlos| MySQL   | Banco de Dados| 9    | 10-04-2024 |

Exemplo 5: Mostrar a quantidade de matrículas, agrupada pela descrição da categoria do curso. Porém, somente os registros entre 01-12-2023 e 30-05-2024”. Mostre apenas aqueles cuja quantidade seja maior que 1.

```sql
SELECT cat.descricao "Categoria", count(m.codcur) "Qtd"
FROM curso c INNER JOIN matricula m ON m.codcur=c.codcur
INNER JOIN categoria cat ON cat.codcat=c.categoria 
WHERE m.datacurso BETWEEN '2023-12-01' AND '2024-05-30'
GROUP BY cat.descricao
HAVING count(m.codcur) > 1;
```
| Categoria     | Qtd |
|---------------|-----|
| Programação   | 3   |
| Banco de Dados| 2   |

Exemplo 6: Listar o nome dos alunos que estão matriculados em pelo menos dois cursos diferentes.
```sql
SELECT
    a.nome AS nome_aluno
FROM
    aluno AS a
JOIN
    matricula AS m ON a.codalu = m.codalu
GROUP BY
    a.nome
HAVING
    COUNT(DISTINCT m.codcur) >= 2;
 ```   
| nome_aluno |
|------------|
| Celso      |
| Maria      |

Exemplo 7: Liste as categorias de cursos e o preço médio dos cursos em cada categoria, mostrando apenas as categorias com preço médio superior a 700.

```sql
SELECT
    cat.descricao AS nome_categoria,
    AVG(cu.preco) AS preco_medio
FROM
    categoria AS cat
JOIN
    curso AS cu ON cat.codcat = cu.categoria
GROUP BY
    cat.descricao
HAVING
    AVG(cu.preco) > 700
ORDER BY
    cat.descricao;
```
| nome_categoria  | preco_medio |
|-----------------|-------------|
| Machine Learning| 1000.00     |
| Programação     | 950.00      |

### LEFT JOIN
LEFT JOIN (ou LEFT OUTER JOIN): Retorna todas as linhas da tabela da esquerda (a primeira tabela mencionada no FROM) e as linhas correspondentes da tabela da direita. Se não houver correspondência na tabela da direita, as colunas da direita terão valores NULL.

Exemplo 1: Listar os nomes das categorias e os cursos associados à elas. Traga também categorias que não possuem nenhum curso associado

```sql
SELECT cat.descricao, c. codcur, c. nome, c. cargahoraria, c. preco 
FROM categoria cat LEFT JOIN curso c 
ON c.categoria=cat.codcat;
```

| descricao       | codcur | nome          | cargahoraria | preco   |
|-----------------|--------|---------------|--------------|---------|
| Programação     | 1      | Java          | 30           | 400.00  |
| Banco de Dados  | 2      | PostgreSQL    | 30           | 600.00  |
| Machine Learning| 3      | Deep Learning | 20           | 1000.00 |
| Programação     | 4      | Python        | 20           | 500.00  |
| Banco de Dados  | 5      | MySQL         | 30           | 500.00  |
| Redes           |        |               |              |         |

Exemplo 2: Listar os nomes das cidades e os nomes dos alunos pertencentes a elas. Traga também cidades que não possuem nenhum aluno associado

```sql
SELECT c.nome, a.nome
FROM cidade c LEFT JOIN aluno a 
ON c.codcid=a.cidade;
```
| nome          | nome    |
|---------------|---------|
| São Carlos    | Maria   |
| São Carlos    | Celso   |
| Araraquara    | Joaquim |
| Londrina      | Florinda|
| Londrina      | Manoel  |
| Rio de Janeiro|         |
| Curitiba      |         |
| Rio Claro     |         |
| Belo Horizonte|         |


Exemplo 3: Listar os nomes das cidades que não possuem nenhum aluno associado a elas

```sql
SELECT c.nome
FROM cidade c LEFT JOIN aluno a 
ON c.codcid=a.cidade
WHERE a.cidade is NULL;
```
| nome          |
|---------------|
| Rio de Janeiro|
| Curitiba      |
| Rio Claro     |
| Belo Horizonte|

Exemplo 4: Listar todos os cursos e, se houver alguma matrícula, mostrar o nome do aluno matriculado.

```sql
SELECT c.nome AS nome_curso, a.nome AS nome_aluno
FROM curso AS c LEFT JOIN matricula AS m 
ON c.codcur = m.codcur
LEFT JOIN aluno AS a ON m.codalu = a.codalu;
```    
| nome_curso    | nome_aluno |
|---------------|------------|
| Java          | Maria      |
| PostgreSQL    | Maria      |
| PostgreSQL    | Florinda   |
| Deep Learning |            |
| Python        | Celso      |
| Python        | Celso      |
| MySQL         |            |

### RIGHT JOIN
RIGHT JOIN (ou RIGHT OUTER JOIN): Similar ao LEFT JOIN, mas retorna todas as linhas da tabela da direita e as linhas correspondentes da tabela da esquerda. Se não houver correspondência na tabela da esquerda, as colunas da esquerda terão valores NULL.   

Exemplo: Listar todos os alunos e suas respectivas cidades. Traga também as cidades que não possuam nenhum aluno associado a elas.

```sql
SELECT a.codalu, a.cpf, a.nome, a.telefone, c.nome, c.uf
FROM aluno a RIGHT JOIN cidade c
ON a.cidade=c.codcid;
```
| codalu | cpf           | nome      | telefone    | nome          | uf |
|--------|---------------|-----------|-------------|---------------|----|
| 1      | 11111111111   | Maria     | 9999-9999   | São Carlos    | SP |
| 2      | 22222222222   | Celso     | 8888-8888   | São Carlos    | SP |
| 3      | 33333333333   | Joaquim   | 7777-7777   | Araraquara    | SP |
| 4      | 44444444444   | Florinda  | 6666-6666   | Londrina      | PR |
| 5      | 55555555555   | Manoel    |             | Londrina      | PR |
|        |               |           |             | Rio de Janeiro| RJ |
|        |               |           |             | Curitiba      | PR |
|        |               |           |             | Rio Claro     | SP |
|        |               |           |             | Belo Horizonte| MG |

### FULL JOIN
FULL OUTER JOIN (ou FULL JOIN): Retorna todas as linhas de ambas as tabelas. Se não houver correspondência entre as tabelas, as colunas da tabela sem correspondência terão valores NULL.

Exemplo: Todas as linhas de todas as tabelas. Essa consulta lista todos os alunos e suas respectivas cidades (quando encontradas), bem como todas as cidades, mostrando NULL para as informações dos alunos nas cidades que não têm nenhum aluno cadastrado.
```sql
SELECT a.codalu, a.cpf, a.nome, a.telefone, c.nome, c.uf
FROM aluno a FULL JOIN cidade c
ON a.cidade=c.codcid;
```
| codalu | cpf           | nome      | telefone    | nome          | uf |
|--------|---------------|-----------|-------------|---------------|----|
| 1      | 11111111111   | Maria     | 9999-9999   | São Carlos    | SP |
| 2      | 22222222222   | Celso     | 8888-8888   | São Carlos    | SP |
| 3      | 33333333333   | Joaquim   | 7777-7777   | Araraquara    | SP |
| 4      | 44444444444   | Florinda  | 6666-6666   | Londrina      | PR |
| 5      | 55555555555   | Manoel    |             | Londrina      | PR |
|        |               |           |             | Rio de Janeiro| RJ |
|        |               |           |             | Curitiba      | PR |
|        |               |           |             | Rio Claro     | SP |
|        |               |           |             | Belo Horizonte| MG |

### CROSS JOIN
CROSS JOIN (ou produto cartesiano): Retorna todas as combinações possíveis de linhas entre as duas tabelas. Se a tabela A tem 'n' linhas e a tabela B tem 'm' linhas, o resultado terá 'n * m' linhas. Geralmente, usa-se com cuidado, pois pode gerar resultados muito grandes.

```sql
SELECT
c.nome  nome_curso,
cat.descricao  nome_categoria
FROM curso c CROSS JOIN categoria cat;
```    
| nome_curso    | nome_categoria  |
|---------------|-----------------|
| Java          | Programação     |
| Java          | Banco de Dados  |
| Java          | Machine Learning|
| Java          | Redes           |
| PostgreSQL    | Programação     |
| PostgreSQL    | Banco de Dados  |
| PostgreSQL    | Machine Learning|
| PostgreSQL    | Redes           |
| Deep Learning | Programação     |
| Deep Learning | Banco de Dados  |
| Deep Learning | Machine Learning|
| Deep Learning | Redes           |
| Python        | Programação     |
| Python        | Banco de Dados  |
| Python        | Machine Learning|
| Python        | Redes           |
| MySQL         | Programação     |
| MySQL         | Banco de Dados  |
| MySQL         | Machine Learning|
| MySQL         | Redes           |

### SELF JOIN
SELF JOIN é usado para juntar uma tabela com ela mesma. Isso é útil quando há uma relação hierárquica ou quando você precisa comparar linhas dentro da mesma tabela.

Por exemplo, se a tabela aluno tivesse uma coluna referenciando um "responsável" (que também seria um aluno), você poderia usar um SELF JOIN para listar o aluno e seu responsável. 

Outro exemplo: A consulta retorna pares de alunos diferentes que moram na mesma cidade.

```sql
SELECT
a1.nome AS aluno1,
a2.nome AS aluno2,
a1.cidade AS cidade_aluno1
FROM aluno AS a1
INNER JOIN aluno AS a2 
ON a1.cidade = a2.cidade AND a1.codalu <> a2.codalu;
```    
| aluno1  | aluno2  | cidade_aluno1 |
|---------|---------|---------------|
| Maria   | Celso   | 1             |
| Celso   | Maria   | 1             |
| Florinda| Manoel  | 3             |
| Manoel  | Florinda| 3             |