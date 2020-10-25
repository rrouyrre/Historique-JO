-- 1. Quelles sont les nationalités qui ne sont pas apparues sur au moins un podium de 100m?
SELECT DISTINCT nomPays
FROM Sportif
WHERE idSportif NOT IN (
	SELECT idSportif
    FROM Performance
    WHERE Performance.idDiscipline = 1
    AND Performance.medaille <> 'N'
);


-- 2. Comment s'appellent les sportifs jamaïquains ayant disputé au moins une épreuve d'athlétisme ?
SELECT prenom, nomS AS nom
FROM Sportif
WHERE nomPays='Jamaique' 
AND idSportif IN (
	SELECT idSportif 
	FROM Performance 
	WHERE idDiscipline IN (
	    SELECT idDiscipline
	    FROM Discipline
	    WHERE nomD='Athletisme'
	)    
);


-- 3. Comment s’appellent les sportifs Jamaïquains ayant pratiqué le 100m, quelle a été leur performance, lors de quelle(s) édition(s) ?
SELECT prenom, nomS AS nom, score, medaille, record, annee, eteOuHiver AS saison, ville
FROM Sportif, Performance, Edition
WHERE Sportif.nomPays='Jamaique' 
AND Sportif.idSportif=Performance.idSportif
AND Performance.idDiscipline=1
AND Performance.idEdition=Edition.idEdition;


-- 4. Quels ont été les podiums des épreuves du 200m disputées?
SELECT p1.idSportif as 'Or', p2.idSportif as 'Argent', p3.idSportif as 'Bronze', p1.idEdition
FROM Performance p1, Performance p2, Performance p3
WHERE p1.medaille = 'Or'
AND p1.idDiscipline = 2
AND p2.medaille = 'Ar'
AND p2.idDiscipline = 2
AND p3.medaille = 'Br'
AND p3.idDiscipline = 2
AND p1.idEdition = p2.idEdition
AND p3.idEdition = p2.idEdition;


-- 5. Qui sont les sportifs qui ont aujourd'hui moins de 35 ans ?
SELECT sexe, prenom, nom, age, nomPays
FROM (
	SELECT sexe, prenom, nomS AS nom, date_naissance, YEAR(NOW()) - YEAR(date_naissance) AS age, nomPays
	FROM Sportif) AS sportif_et_age
WHERE age < 35
ORDER BY sexe, age;


-- 6. Quels sont les sportifs qui portent le même prénom ?
SELECT * 
FROM   Sportif C1
WHERE  EXISTS (
    SELECT * 
        FROM   Sportif C2
        WHERE  C1.idSportif <> C2.idSportif
     AND C1.prenom = C2.prenom
);


-- 7. Combien de peformances a effectuées Usain Bolt ?
SELECT prenom, nomS AS nom, COUNT(score) AS nb_perf
FROM Sportif, Performance
WHERE Performance.idSportif=1
AND Sportif.idSportif=Performance.idSportif
GROUP BY prenom, nomS;


-- 8. Quelles sont les disciplines présentes à toutes les éditions estivales ?
SELECT DISTINCT idDiscipline FROM Propose
WHERE NOT EXISTS 
	(SELECT * FROM Edition
	WHERE NOT EXISTS 
		(SELECT * FROM Edition e, Propose p
		WHERE e.idEdition = p.idEdition
		AND Propose.idDiscipline = p.idDiscipline
		AND e.idEdition = Edition.idEdition
	) AND Edition.eteOuHiver='E'
);


-- 9. Qui sont les sportifs Jamaicains dont le nom commence par un W ?
SELECT * 
FROM Sportif
WHERE nomPays='Jamaique'
AND nomS LIKE 'W%';


-- 10. Quelle est la moyenne d'âge des sportifs pour l'épreuve de bobsleigh en 2014 ?
SELECT AVG(age)
FROM (
	SELECT prenom, nomS AS nom, date_naissance, annee - YEAR(date_naissance) AS age
	FROM Sportif, Performance, Discipline, Edition
	WHERE Discipline.nomD='Bobsleigh'
	AND Sportif.idSportif=Performance.idSportif
	AND Performance.idDiscipline=Discipline.idDiscipline
    AND Edition.idEdition = 2
    AND Edition.idEdition = Performance.idEdition
)AS sportif_et_age;


-- 11. Quel est le record olympique jamaïquain au 100m ?
SELECT MIN(score) AS record_olympique_jamaiquain
FROM (
	SELECT prenom, nomS AS nom, score
	FROM Sportif, Performance
	WHERE Sportif.nomPays='Jamaique' 
	AND Sportif.idSportif=Performance.idSportif
	AND Performance.idDiscipline=1
) AS performances_jamaiquaines;


-- 12. Quels sont les pays ayant proposé des sportifs et/ou accueilli une édition ?
SELECT  nomPays  FROM  Sportif
UNION
SELECT  nomPays  FROM  Edition;



-- -------------Bonus------------


-- Requêtes bonus que nous avons choisies de ne pas intégrer dans le raport mais qui fonctionnent

-- Combien de sportifs jamaïcains ont couru le 100m en moins de 10 secondes (aux JO) ? 
SELECT prenom, nom, COUNT(prenom) AS nb_perf
FROM (
	SELECT prenom, nomS AS nom, score
	FROM Sportif, Performance
	WHERE Sportif.nomPays='Jamaique' 
	AND Sportif.idSportif=Performance.idSportif
	AND Performance.idDiscipline=1
	AND Performance.score < '9,99s'
) AS performances_jamaicaines
GROUP BY prenom, nom;


-- Quels sont les sportifs qui ont établi au moins 2 records du monde au cours d'une même édition ?
SELECT prenom, nom
FROM (
	SELECT prenom, nomS AS nom, COUNT(record) AS nb_WR
	FROM Sportif, Performance
	WHERE Sportif.idSportif=Performance.idSportif
	AND Performance.record='Mondial'
	GROUP BY prenom, nomS
) AS sportif_record
WHERE nb_WR >= 2;


-- Quelles sportives composaient le 4*400 jamaïcain en 2008 ?
SELECT prenom, nomS AS nom 
FROM Sportif, Performance, Discipline, Edition
WHERE Sportif.idSportif=Performance.idSportif
AND Sportif.sexe='F'
AND Sportif.nomPays='Jamaique'
AND Edition.annee=2008
AND Performance.idDiscipline=Discipline.idDiscipline
AND Discipline.categorie='4x400m';


