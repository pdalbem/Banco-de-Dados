--1
select codcur, nome, cargahoraria
from curso
where cargahoraria = (select max(cargahoraria) from curso);

--2
select codcur, count(codcur) "qtd"
from matricula
group by codcur;

--3
select codalu, count(codalu) "qtd"
from matricula
group by codalu;

--4
select codalu, count(codalu) "qtd"
from matricula
where datacurso between '2024-03-01' and '2024-05-03'
group by codalu;

--5
select codalu, count(codalu) "qtd"
from matricula
where datacurso between '2024-03-01' and '2024-05-03'
group by codalu
having count(codalu)>1;
