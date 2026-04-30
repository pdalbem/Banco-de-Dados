--1) Cursos da categoria 1, ordenados pelo preço (maior → menor)
SELECT codcur, nome, preco
FROM curso
WHERE categoria = 1
ORDER BY preco DESC;

--2) Cursos com carga horária > 20 e categoria 1 ou 2
SELECT codcur, nome, cargahoraria, categoria
FROM curso
WHERE cargahoraria > 20
  AND categoria IN (1, 2);

--3) Alunos sem telefone cadastrado
SELECT codalu, nome
FROM aluno
WHERE telefone IS NULL;

--4) Quantos cursos diferentes existem na tabela de matrícula
SELECT COUNT(DISTINCT codcur) AS quantidade
FROM matricula;

--5) Datas com mais de uma matrícula
SELECT datacurso, COUNT(*) AS quantidade
FROM matricula
GROUP BY datacurso
HAVING COUNT(*) > 1;

--6) Quantidade de matrículas por aluno
SELECT codalu, COUNT(*) AS quantidade
FROM matricula
GROUP BY codalu;

--7) Matrículas por aluno (somente matrículas efetuadas entre 01/03/2024 e 03/05/2024)
SELECT codalu, COUNT(*) AS quantidade
FROM matricula
WHERE datacurso BETWEEN '2024-03-01' AND '2024-05-03'
GROUP BY codalu;

--8) Qquantidade de matrículas, agrupada por alunos. Porém, considere somente matrículas efetuadas entre 01/03/2024 e 03/05/2024. Mostre somente os casos em que a quantidade é maior que 1;
SELECT codalu, COUNT(*) AS quantidade
FROM matricula
WHERE datacurso BETWEEN '2024-03-01' AND '2024-05-03'
GROUP BY codalu
HAVING COUNT(*) > 1;

--9) Média de notas por curso (> 9.0)
SELECT codcur, AVG(nota) AS media
FROM matricula
GROUP BY codcur
HAVING AVG(nota) > 9.0;
