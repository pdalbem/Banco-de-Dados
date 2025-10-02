--01
select * from aluno
where cidade=(select codcid from cidade where nome='São Carlos' and uf='SP');


--02
select * from curso
where cargahoraria>(select cargahoraria from curso where nome='Python');


--03
select a.nome, count(m.codalu)
from aluno a inner join matricula m
on a.codalu=m.codalu
group by a.nome
having count(m.codalu)=(select count(m.codalu)
	                    from matricula m
	                    group by m.codalu
	                    order by count(m.codalu) 
	                    limit 1);
	                    
--03 usando o MIN em mais uma subconsulta
select a.nome, count(m.codalu)
from aluno a inner join matricula m
on a.codalu=m.codalu
group by a.nome
having count(m.codalu)=(select min(matriculas)
                        from (select count(m.codalu) as "matriculas"
			      from matricula m group by m.codalu));  



-04
select c.nome, cat.descricao, count(m.codcur)
from curso c inner join matricula m
on c.codcur=m.codcur
inner join categoria cat on cat.codcat=c.categoria	
group by c.nome,cat.descricao
having count(m.codcur)=(select count(m.codcur)
	                    from matricula m
	                    group by m.codcur
	                    order by count(m.codcur) desc
	                    limit 1);


--04 Outra forma: usando o MAX em mais uma subconsulta
select c.nome, cat.descricao, count(m.codcur)
from curso c inner join matricula m
on c.codcur=m.codcur
inner join categoria cat on cat.codcat=c.categoria	
group by c.nome,cat.descricao
having count(m.codcur)=(select max(matriculas) 
                        from (select count(m.codcur) as "matriculas"
			      from matricula m group by m.codcur));

--05 Usando IN
select c.nome,cat.descricao 
from curso c inner join categoria cat
on c.categoria=cat.codcat
where c.categoria in (select categoria from curso
	                where nome in ('Java','MySQL'));

--05 Usando Any	
select c.nome,cat.descricao 
from curso c inner join categoria cat
on c.categoria=cat.codcat
where c.categoria = ANY (select categoria from curso
	                   where nome in ('Java','MySQL'));


--06 Usando IN
select c.nome from curso c
where c.codcur IN (select codcur from  matricula);

--06 Usando ANY
select c.nome from curso c
where c.codcur =ANY (select codcur from  matricula);
	
--06 Usando correlacionada
select c.nome from curso c
where exists (select 1 from matricula m where m.codcur=c.codcur);

	
	
--07 Usando NOT IN
select c.nome from cidade c
where c.codcid not in (select cidade from aluno where cidade is not null);

--07 Usando != ALL	
select c.nome from cidade c
where c.codcid != ALL (select cidade from aluno where cidade is not null);

--07 Usando Consulta correlacionada
select c.nome from cidade c
where NOT EXISTS (select 1 from aluno a where a.cidade=c.codcid);
	
	
--08 Usando NOT IN
select a.nome from aluno a
where a.codalu not in (select codalu from matricula where codalu is not null);

--08 Usando !=ALL
select a.nome from aluno a
where a.codalu != ALL (select codalu from matricula where codalu is not null);

--08 Usando consulta correlacionada
select a.nome from aluno a
where NOT EXISTS (select 1 from matricula m where m.codalu=a.codalu);

--09
select c.nome from curso c
where categoria in (select codcat 
	                from categoria where descricao='Programação');
union					 
select c.nome from curso c
where categoria in (select codcat 
	                from categoria where  descricao='Machine Learning');
intersect
select c.nome from curso c
inner join matricula m on c.codcur=m.codcur
where m.datacurso > '2024-2-01';

--10
create view vw_qtd_matricula as
select cat.descricao, count(m.codcur)
from categoria cat inner join curso c
on cat.codcat=c.categoria inner join matricula m
on m.codcur=c.codcur
group by cat.descricao;


