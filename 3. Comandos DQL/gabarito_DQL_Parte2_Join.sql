--1
select a.nome, a.cpf, c.nome, c.uf
from aluno a inner join cidade c
on a.cidade=c.codcid
where c.uf in ('SP','PR','MG')
order by a.nome;

--2
select cat.descricao, count (c.codcur), avg(c.preco), max(c.preco), min(c.preco)
from categoria cat inner join curso c
on cat.codcat=c.categoria
group by cat.descricao;

--3
select c.uf, count(a.codalu)
from cidade c inner join aluno a
on c.codcid=a.cidade
group by c.uf
having count(a.codalu)>2

--4
select c.nome, count(m.codcur)
from curso c inner join matricula m
on c.codcur=m.codcur
group by c.nome;

--5
select a.nome, count(m.codalu)
from aluno a inner join matricula m
on a.codalu=m.codalu
group by a.nome;

--6
select a.nome, count(m.codalu) "Qtd"
from aluno a inner join matricula m
on a.codalu=m.codalu
where m.datacurso between '2024-02-01' and '2024-05-03'
group by a.nome
having count(m.codalu)>1;

--7
select c.nome, count(m.codalu) "Qtd"
from matricula m inner join aluno a
on a.codalu=m.codalu inner join
cidade c on a.cidade=c.codcid
group by c.nome
order by "Qtd" desc;

--8
select c.nome, max(m.nota), min(m.nota), avg(m.nota)
from curso c inner join matricula m
on c.codcur=m.codcur
group by c.nome
order by c.nome;

--9 usando left join
select cat.descricao
from categoria cat left join curso c
on cat.codcat=c.categoria
where c.categoria is  null
order by cat.descricao;

--9 usando right join
select cat.descricao
from curso c right join categoria cat
on cat.codcat=c.categoria
where c.categoria is null
order by cat.descricao;

--10
select a.nome
from aluno a left join matricula m
on a.codalu=m.codalu
where m.codalu is null
order by a.nome;

--11
select a.nome, m.datacurso
from aluno a left join matricula m
on a.codalu=m.codalu
where extract(month from m.datacurso)!=4
or m.codalu is null
order by a.nome;
































