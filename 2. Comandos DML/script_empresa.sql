--COmandos DDL para criação das tabelas
CREATE TABLE departamento (
    coddep int PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    localizacao VARCHAR(30)
);

CREATE TABLE funcionario (
    codfunc int PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    salario decimal(10,2) NOT NULL check(salario>0),
    data_contratacao DATE NOT NULL,
    departamento INT,
	constraint fk_depto FOREIGN KEY (departamento) REFERENCES departamento(coddep)
);

---------------------------------------------------------------------
--Comandos DML para inserção de registros
INSERT INTO departamento (coddep, nome, localizacao) VALUES
(1,'Recursos Humanos', 'Prédio A');

INSERT INTO departamento VALUES
(2,'Tecnologia', 'Prédio B');

INSERT INTO departamento VALUES
(3,'Financeiro', 'Prédio C'),        
(4, 'Marketing', 'Prédio D');         


-- Funcionários 
INSERT INTO funcionario (codfunc, nome, salario, data_contratacao, departamento) VALUES
(1,'Mariana', 5000.00, '2021-09-01', 2),
(2,'Joaquim', 3800.00, '2024-03-01', 2),
(3, 'José', 4500.00, '2022-05-20', 4),
(4, 'João', 4200.00, '2024-08-10', 4),
(5, 'Ana Souza', 3500.00, '2023-01-10', 1),
-------------------------------------------------------
--Comando UPDATE
--CUIDADO com comando UPDATE SEM cláusula WHERE
update departamento
set localizacao = 'Bloco A'
where coddep=1;

update funcionario
set salario = 5000
where codfunc=1;

update funcionario
set salario = salario *1.10
where departamento =2;

update funcionario
set salario = salario *1.10
where departamento=2 or departamento=4;

update funcionario
set salario = salario*1.10
where data_contratacao < '2023-1-1'; 

update funcionario
set salario = salario *1.10
where (departamento=2 or departamento=4) and data_contratacao<'2023-1-1';

update departamento
set coddep=100
where coddep=1;
-------------------------------

--Comando DELETE
--CUIDADO com comando DELETE sem WHERE

delete FROM funcionario 
where codfunc=5;

delete from funcionario 
where departamento=2 or departamento=4;


delete from departamento 
where coddep=1; --violação integridade, SGBD não deixa excluir
------------------------------------------------------------------
-- Alterar a tabela para inserir as cláusulas on update e on delete na definição da FK
alter table funcionario
drop constraint fk_depto;

alter table funcionario
add constraint fk_depto FOREIGN KEY (departamento) REFERENCES departamento (coddep)
on update cascade on delete set null;
-------------------------------------------------------------------
