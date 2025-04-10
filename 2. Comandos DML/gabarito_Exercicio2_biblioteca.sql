create table editora
(codeditora int primary key,
 nome_fantasia varchar(50) not null	
);

create table livro
(
  codlivro int primary key,
  titulo varchar(50) not null,
  editora int,
  constraint fk_editora foreign key(editora) 
	references editora(codeditora)	
);

create table autor
(
  codautor int primary key,
  nome varchar(40) not null
);

create table autorlivro
(
  codlivro int,
  codautor int,
  primary key(codlivro,codautor),
  constraint fk_livro foreign key(codlivro)
	references livro(codlivro)
	on update cascade,
  constraint fk_autor foreign key(codautor)
	references autor(codautor)
	on update cascade
);

create table exemplar
(
  tombo int primary key,
  codlivro int,
  status varchar(15) default 'disponível',
  constraint fk_livro foreign key(codlivro)
	references livro(codlivro)
	on update cascade on delete set null
);

create table usuario
(
	codusuario int primary key,
	nome varchar(50) not null
);

create table emprestimo
(
	codemp int primary key,
	codusuario int,
	codexemplar int,
	data_retirada date not null,
	data_prevista_devolucao date 
	check(data_prevista_devolucao>=data_retirada),
	data_devolucao date
	check(data_devolucao>=data_retirada),
	constraint fk_exemplar foreign key(codexemplar)
	references exemplar(tombo)
	on update cascade on delete set null,
	constraint fk_usuario foreign key(codusuario)
	references usuario(codusuario)
	on update cascade on delete set null
);

-- 3
alter table editora 
add cnpj char(20) unique;

-- 4
alter table livro
drop constraint fk_editora;

alter table livro
add constraint fk_editora foreign key(editora)
references editora(codeditora)
on update cascade on delete set null;

-- 5 
insert into editora values
	(1,'Pearson','88888'),
	(2,'LTC','777');

insert into autor values
	(1,'Deitel'),
	(2,'Maria');

insert into livro values
	(1,'Java',1),
	(2,'Python',2);

insert into autorlivro values
	(1,1),
	(2,2);

insert into exemplar values
	(10,1),
	(11,1),
	(20,2),
	(21,2);

insert into usuario values
	(1,'Joaquim'),
	(2,'Ana');

insert into emprestimo values
	(1,1,10,'2024-04-19','2024-04-21','2024-04-19'),
	(2,1,11,'2024-04-19','2024-04-21','2024-04-19'),
	(3,2,10,'2024-04-15','2024-04-18','2024-04-18');
	
-- 6
update livro
set codlivro=10
where codlivro=1;

-- 7
update exemplar
set status='indisponível'
where tombo=1;

--8
delete from livro
where editora=1 or editora=2;

--9
update emprestimo
set data_prevista_devolucao = data_prevista_devolucao + INTERVAL '3 days'
where codusuario=1 and 
	data_retirada='2024-04-18' or data_retirada='2024-04-19';
	
	

