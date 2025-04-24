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

insert into cidade values
(1,'São Carlos','SP'),
(2,'Araraquara','SP'),
(3, 'Londrina','PR'),
(4,'Rio de Janeiro','RJ'),
(5, 'Curitiba','PR'),
(6, 'Rio Claro','SP'),
(7, 'Belo Horizonte','MG');

insert into aluno values
(1,'11111111111','Maria','9999-9999',1),
(2,'22222222222','Celso','8888-8888',1),
(3,'33333333333','Joaquim','7777-7777',2),
(4,'44444444444','Florinda','6666-6666',3),
(5,'55555555555','Manoel',null,3);

insert into categoria values
(1,'Programação'),
(2,'Banco de Dados'),
(3,'Machine Learning'),
(4, 'Redes');


insert into curso values
(1, 'Java',30,1400.00,1),
(2, 'PostgreSQL',30,600.00,2),
(3, 'Deep Learning',20,1000.00,3),
(4, 'Python', 20,500.00,1),
(5, 'MySQL', 30,500.00,2);

insert into matricula values
(1,1,9.5,'2024-02-14'),
(1,2,10,'2024-03-01'),
(2,4,8.5,'2023-12-10'),
(4,2,9,'2024-04-01'),	
(2,4,9.0,'2024-04-10');






