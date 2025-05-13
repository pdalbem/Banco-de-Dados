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
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    idade INT
);
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
INSERT INTO aluno (nome, idade) VALUES ('Maria', 22);
```

---

## 3. DQL – Data Query Language (Linguagem de Consulta de Dados)

Utilizada para consultar dados no banco.

### Comando principal:
- `SELECT`: Recupera dados das tabelas.

### Exemplo:
```sql
SELECT nome, idade FROM aluno WHERE idade > 20;
```

---

## 4. DCL – Data Control Language (Linguagem de Controle de Dados)

Controla o acesso aos dados e permissões dos usuários.

### Comandos principais:
- `GRANT`: Concede permissões.
- `REVOKE`: Revoga permissões.

### Exemplo:
```sql
GRANT SELECT ON aluno TO usuario1;
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
BEGIN;
UPDATE aluno SET idade = 23 WHERE nome = 'Maria';
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