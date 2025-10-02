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
);

CREATE TABLE curso
(
codcur int PRIMARY KEY,
nome varchar(30) NOT NULL,
cargahoraria int CHECK (cargahoraria > 0)
);

CREATE TABLE matricula
(
  codalu int,
  codcur int,
  nota real CHECK (nota>=0 and nota <=10),
  PRIMARY KEY (codalu,codcur),
  CONSTRAINT fk_aluno FOREIGN KEY (codalu) REFERENCES aluno(codalu),
  CONSTRAINT fk_curso FOREIGN KEY (codcur) REFERENCES curso(codcur)
);

--Resolução dos exercícios DDL
--01
alter table matricula add datacurso date;

--02
alter table curso add preco decimal(10,2) check (preco>0);

--03
create table categoria
(
  codcat int primary key,
  descricao varchar(20) not null
);

alter table curso add categoria int;
alter table curso add constraint fk_categoria foreign key(categoria) references categoria(codcat);

--Resolução dos exercícios DML
--Exercício 1
insert into cidade values
(1,'São Carlos','SP'),
(2,'Araraquara','SP'),
(3, 'Londrina','PR'),
(4,'Rio de Janeiro','RJ');

--Exercício 2
insert into aluno values
(1,'11111111111','Maria','9999-9999',1),
(2,'22222222222','Celso','8888-8888',1),
(3,'33333333333','Joaquim','7777-7777',null),
(4,'44444444444','Florinda','6666-6666',3);

--Exercício 3
insert into categoria values
(1,'Programação'),
(2,'Banco de Dados'),
(3,'Machine Learning'),
(4, 'Redes');

--Exercício 4
insert into curso values
(1, 'Java',30,1400.00,1),
(2, 'PostgreSQL',30,600.00,2),
(3, 'Deep Learning',20,1000.00,4),
(4, 'Python', 20,500.00,1);

--Exercício 5
insert into matricula values
(1,1,9.5,'2024-02-14'),
(1,2,10,'2024-03-01'),
(2,4,8.5,'2023-12-10'),
(4,2,9,'2024-04-01');

--Exercício 6
insert into matricula values
	(2,4,9.0,'2024-04-10');

--Exercício 7
alter table matricula
drop constraint matricula_pkey;

alter table matricula
add constraint matricula_pkey
primary key(codalu,codcur,datacurso);

insert into matricula values
	(2,4,9.0,'2024-04-10');

--Exercício 8
update aluno
set cidade=2
where codalu=3;

--Exercício 9
alter table curso
drop constraint fk_categoria;

alter table curso
add constraint fk_categoria
FOREIGN KEY(categoria) REFERENCES categoria(codcat)
on update cascade on delete set null;

--Exercício 10
update curso
set categoria=3
where codcur=3;

--Exercício 11
alter table matricula
drop constraint fk_curso;

alter table matricula
add constraint fk_curso 
FOREIGN KEY (codcur)
REFERENCES curso(codcur)
ON UPDATE cascade;

--Exercício 12
delete from cidade
where uf='RJ';

--Exercício 13
update curso
set cargahoraria=cargahoraria+10
where categoria=1 OR categoria=2;



