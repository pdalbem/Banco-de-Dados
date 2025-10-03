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
  nota decimal(4,2) CHECK (nota>=0 and nota <=10),
  PRIMARY KEY (codalu,codcur),
  CONSTRAINT fk_aluno FOREIGN KEY (codalu) REFERENCES aluno(codalu),
  CONSTRAINT fk_curso FOREIGN KEY (codcur) REFERENCES curso(codcur)
);

--Resolução dos exercícios propostos
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
