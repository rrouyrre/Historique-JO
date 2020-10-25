DROP DATABASE IF EXISTS projet;
CREATE DATABASE IF NOT EXISTS projet;
USE projet;

DROP TABLE IF EXISTS `Sportif`;

CREATE TABLE `Sportif` (
  `idSportif` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `sexe` char(1) NOT NULL,
  `date_naissance` DATE NOT NULL,
  `nomS` varchar(30) NOT NULL,
  `prenom` varchar(40) NOT NULL,
  `nomPays` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idSportif`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Sportif` WRITE;

LOAD DATA LOCAL INFILE  'Sportif.csv'
INTO TABLE Sportif
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idSportif,sexe,date_naissance,nomS,prenom,nomPays);

UNLOCK TABLES;


#__________PAYS_________________________________
DROP TABLE IF EXISTS `Pays`;

CREATE TABLE `Pays` (
  `nomPays` varchar(30) NOT NULL,
  PRIMARY KEY (`nomPays`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Pays` WRITE;

LOAD DATA LOCAL INFILE 'Pays.csv'
INTO TABLE Pays
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(nomPays);

UNLOCK TABLES;


#__________EDITION_________________________________
DROP TABLE IF EXISTS `Edition`;

CREATE TABLE `Edition` (
  `idEdition` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `annee` smallint(4) unsigned NOT NULL,
  `eteOuHiver` char(1) NOT NULL,
  `ville` varchar(30) NOT NULL,
  `nomPays` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idEdition`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Edition` WRITE;

LOAD DATA LOCAL INFILE 'Edition.csv'
INTO TABLE Edition
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\r\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idEdition,annee,eteOuHiver,ville,nomPays);

UNLOCK TABLES;


#__________DISCIPLINE_________________________________
DROP TABLE IF EXISTS `Discipline`;

CREATE TABLE `Discipline` (
  `idDiscipline` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `sexe` char(1) DEFAULT NULL,
  `nomD` varchar(30) DEFAULT NULL,
  `categorie` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`idDiscipline`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Discipline` WRITE;

LOAD DATA LOCAL INFILE 'Discipline.csv'
INTO TABLE Discipline
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idDiscipline,sexe,nomD,categorie);

UNLOCK TABLES;


#__________PROPOSE_________________________________
DROP TABLE IF EXISTS `Propose`;

CREATE TABLE `Propose` (
  `idDiscipline` smallint(5) unsigned NOT NULL,
  `idEdition` smallint(5) unsigned NOT  NULL,
  PRIMARY KEY (`idEdition`,`idDiscipline`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Propose` WRITE;

LOAD DATA LOCAL INFILE 'Propose.csv'
INTO TABLE Propose
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idDiscipline,idEdition);

UNLOCK TABLES;


#__________PERFORMANCE_________________________________
DROP TABLE IF EXISTS `Performance`;

CREATE TABLE `Performance` (
  `idPerformance` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `idSportif` smallint(5) unsigned NOT NULL,
  `idDiscipline` smallint(5) unsigned NOT NULL,
  `idEdition` smallint(5) unsigned NOT NULL,
  
  `record` char(10) DEFAULT NULL,
  `medaille` char(10) DEFAULT NULL,
  `score` char(10) NOT NULL,
  PRIMARY KEY (`idPerformance`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `Performance` WRITE;

LOAD DATA LOCAL INFILE 'Performance.csv'
INTO TABLE Performance
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idPerformance,idSportif,idDiscipline,idEdition,record,medaille,score);

UNLOCK TABLES;


#__________EQUIPE NATIONALE_________________________________
DROP TABLE IF EXISTS `EquipeNationale`;

CREATE TABLE `EquipeNationale` (
  `idEquipeNationale` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `idSportif` smallint(5) unsigned DEFAULT NULL,
  `idEdition` smallint(5) unsigned DEFAULT NULL,

  `nomPays` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idEquipeNationale`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

LOCK TABLES `EquipeNationale` WRITE;

LOAD DATA LOCAL INFILE 'EquipeNationale.csv'
INTO TABLE EquipeNationale
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(idEquipeNationale,idSportif,idEdition,nomPays);

UNLOCK TABLES;


ALTER TABLE Sportif ADD FOREIGN KEY (nomPays) REFERENCES Pays(nomPays);
ALTER TABLE Edition ADD FOREIGN KEY (nomPays) REFERENCES Pays(nomPays);

ALTER TABLE Performance ADD FOREIGN KEY (idSportif) REFERENCES Sportif(idSportif);
ALTER TABLE Performance ADD FOREIGN KEY (idDiscipline) REFERENCES Discipline(idDiscipline);
ALTER TABLE Performance ADD FOREIGN KEY (idEdition) REFERENCES Edition(idEdition);

ALTER TABLE EquipeNationale ADD FOREIGN KEY (idSportif) REFERENCES Sportif(idSportif);
ALTER TABLE EquipeNationale ADD FOREIGN KEY (idEdition) REFERENCES Edition(idEdition);
ALTER TABLE EquipeNationale ADD FOREIGN KEY (nomPays) REFERENCES Pays(nomPays);

