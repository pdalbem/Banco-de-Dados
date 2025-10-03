# Banco de Dados
Material da disciplina de Banco de Dados I (BDD1).


# Structured Query Language (SQL)

SQL (Structured Query Language) é a linguagem padrão para gerenciamento de bancos de dados relacionais. 
Ela se divide em várias categorias de comandos, conforme a finalidade de uso.

---

## 1. DDL – Data Definition Language (Linguagem de Definição de Dados)

Usada para definir e modificar a estrutura dos objetos do banco de dados.

### Comandos principais:
- `CREATE`: Cria objetos como tabelas e índices.
- `ALTER`: Altera a estrutura de objetos existentes.
- `DROP`: Exclui objetos do banco de dados.
- `TRUNCATE`: Remove todos os dados de uma tabela, mantendo sua estrutura.

### Exemplo:
```sql
CREATE TABLE aluno (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    idade INT
);

-- Alterando a tabela para adicionar uma nova coluna
ALTER TABLE aluno ADD COLUMN email VARCHAR(150);

-- Excluindo a tabela
DROP TABLE aluno;

-- Removendo todos os dados da tabela, mas mantendo a estrutura
TRUNCATE TABLE aluno;

```

---

## 2. DML – Data Manipulation Language (Linguagem de Manipulação de Dados)

Usada para inserir, atualizar e excluir dados nas tabelas.

### Comandos principais:
- `INSERT`: Insere novos dados.
- `UPDATE`: Altera dados existentes.
- `DELETE`: Exclui dados existentes.

### Exemplo:
```sql
-- Inserindo dados
INSERT INTO aluno (id, nome, idade, email) 
VALUES (1, 'Maria', 22, 'maria@email.com');

INSERT INTO aluno VALUES (2, 'João', 20, 'joao@email.com');

-- Atualizando dados
UPDATE aluno SET idade = 23 WHERE id = 1;

-- Excluindo um aluno
DELETE FROM aluno WHERE nome = 'João';
```

---

## 3. DQL – Data Query Language (Linguagem de Consulta de Dados)

Utilizada para consultar dados no banco.

### Comando principal:
- `SELECT`: Recupera dados das tabelas.

### Exemplo:
```sql
-- Consultando todos os dados da tabela
SELECT * FROM aluno;

-- Consultando somente alguns campos
SELECT nome, idade FROM aluno;

-- Aplicando condições
SELECT nome FROM aluno WHERE idade > 20;

-- Ordenando resultados
SELECT nome, idade FROM aluno ORDER BY idade DESC;

-- Agregando dados (quantos alunos existem)
SELECT COUNT(*) AS total_alunos FROM aluno;

-- Agrupando por idade
SELECT idade, COUNT(*) FROM aluno GROUP BY idade;
```

---

## 4. DCL – Data Control Language (Linguagem de Controle de Dados)

Controla o acesso aos dados e permissões dos usuários.

### Comandos principais:
- `GRANT`: Concede permissões.
- `REVOKE`: Revoga permissões.

### Exemplo:
```sql
-- Concedendo permissão de SELECT ao usuário
GRANT SELECT ON aluno TO usuario1;

-- Concedendo permissão total
GRANT ALL PRIVILEGES ON aluno TO usuario2;

-- Revogando permissão
REVOKE SELECT ON aluno FROM usuario1;
```

---

## 5. TCL – Transaction Control Language (Linguagem de Controle de Transações)

Gerencia transações e garante a integridade dos dados.

### Comandos principais:
- `BEGIN` ou `START TRANSACTION`: Inicia uma transação.
- `COMMIT`: Confirma as alterações.
- `ROLLBACK`: Desfaz alterações feitas desde o início da transação.

### Exemplo:
```sql
-- Iniciando uma transação
BEGIN;

-- Atualizando dados
UPDATE aluno SET idade = 25 WHERE id = 2;

-- Confirmando as alterações
COMMIT;

-- Exemplo com ROLLBACK
BEGIN;
DELETE FROM aluno WHERE id = 1;

-- Ops, erro! Desfazendo
ROLLBACK;

-- Exemplo com SAVEPOINT
BEGIN;
UPDATE aluno SET idade = 30 WHERE id = 2;
SAVEPOINT antes_exclusao;
DELETE FROM aluno WHERE id = 2;

-- Se quiser voltar ao ponto antes da exclusão
ROLLBACK TO antes_exclusao;
COMMIT;
```

---

## Resumo das Categorias

| Categoria | Nome Completo                    | Exemplos de Comandos           |
|-----------|----------------------------------|--------------------------------|
| DDL       | Data Definition Language         | `CREATE`, `ALTER`, `DROP`      |
| DML       | Data Manipulation Language       | `INSERT`, `UPDATE`, `DELETE`   |
| DQL       | Data Query Language              | `SELECT`                       |
| DCL       | Data Control Language            | `GRANT`, `REVOKE`              |
| TCL       | Transaction Control Language     | `BEGIN`, `COMMIT`, `ROLLBACK`  |