# Requete SQL

##1)	Création une base de donnée appelée « Biblio » 
create database Biblio ;

## 2)	Crée toutes les tables requise à la gestion de Bibliothèque 
create table auteur( 
id_auteur serial primary key ,
nom_aut varchar(25),
prenom_aut varchar(25),
date_auteur date
);
create table editeur( 
id_editeur serial primary key ,
libelle varchar(40)
);

create table emprunteur( 
id_emprunteur serial primary key ,
nom_empr varchar(25),
prenom_empr varchar(25),
adresse_actuel varchar(50),
num_tel int,
date_inscrip date,
statut_cot varchar(15)
);

create table livre( 
isbm serial primary key ,
date_edition date,
titre_livre varchar(20),
id_editeur INT REFERENCES editeur(id_editeur)
);

create table ecrire(
id_auteur INT REFERENCES auteur(id_auteur),
isbm INT REFERENCES livre(isbm)
);

create table exemplaire( 
id_exemplaire serial primary key ,
valeur_remplacement numeric(8,2),
isbm INT REFERENCES livre(isbm)
);

create table emprunt(
date_emprunt date,
date_retour date,
id_exemplaire INT REFERENCES exemplaire(id_exemplaire),
id_emprunteur INT REFERENCES emprunteur(id_emprunteur),
date_retourf date,
statut varchar(25)
);


Insertion des donnée : 
--insert auteur
INSERT INTO auteur (nom_aut, prenom_aut, date_auteur) 
VALUES ('Ben Salah', 'mohammed', '1975-03-12'),
		('El Fassi', 'Youssef', '1988-08-25'),
		('Rahmani', 'Sara', '1995-11-04');
--insert to editeur
INSERT INTO editeur(libelle) 
VALUES ('Dar Attakafa'),
 		('Al Hikma'),
 		('Arab Scientific');
--insert emprunteur
INSERT INTO public.emprunteur
( nom_empr, prenom_empr, adresse_actuel, num_tel, date_inscrip, statut_cot)
VALUES('Saidi', 'Khalid', 'Tanger',0662223344, '2018-05-20', 'Actif'),
		('El Alami', 'Hiba', 'Agadir', 665554433, '2017-12-10', 'Inactif'),
		('Bensaid', 'Omar', 'Fès',0661112233, '2019-10-15', 'Actif');
-- insert to livre 
	INSERT INTO livre (date_edition, id_editeur,titre_livre) 
VALUES ('2008-07-30', 3,'html'),
     ('2015-04-18', 1,'c++'),
        ('2019-11-22', 'css');	
--insert to ecrire 
       INSERT INTO ecrire (id_auteur, isbm) 
      VALUES (3, 3),
      (2, 2),	
     (1, 1);
--insert to exemplaire 
    INSERT INTO exemplaire (valeur_remplacement, isbm) 
   VALUES (180.00, 1),
           (220.00, 2),
           (170.00, 2);
--insert to emprunt
          INSERT INTO emprunt (date_emprunt, date_retour, id_exemplaire, id_emprunteur, date_retourf, statut)
      VALUES ('2023-03-10', '2025-03-25', 3, 3, NULL, 'Détruit'),
            ('2023-02-05','2024-02-25', 2, 3,'2023-02-15', 'perdu'),
           ('2023-04-05','2024-04-25', 1, 3,'2023-04-24', 'bien'),
          ('2023-04-05','2024-04-25', 1, 2,NULL, 'bien'),
         ('2023-04-05','2024-04-25', 2, 2,'2023-04-24', 'bien'),
        ('2023-04-05','2024-04-25', 3, 2,'2023-04-24', 'bien'),
       ('2023-04-05','2024-04-25', 1, 3,'2023-04-24','bien');



## 3)	Calculer le nombre d’exemplaire par livre 
	--q3 Calcul le nbr d'exeplaire par livre 

select titre_livre , count(id_exemplaire) as nbr_exemplaire  
from  exemplaire e , livre l
where l.isbm = e.isbm
group by titre_livre
having count(id_exemplaire) >= 0 


## 4)	Quelle livre à la plus petite valeur de remplacement 
--q4 quelle livre à la plus petit valeur de remplacement 
 select titre_livre , min(valeur_remplacement) as min_remplacement
 from livre l , exemplaire e
 where l.isbm = e.isbm 
 group by titre_livre 
 order by min(valeur_remplacement) asc 
 limit 1



## 5)	A la date d’aujourd’hui, afficher les noms des emprunteurs qui n’ont pas encore rendue leurs livres
--q5 afficher le nom des emprunteurs qui non pas rendue leurs livre à la date d'aujord'hui 
 -- aujourd'hui <=> 'now'
 select nom_empr 
 from emprunteur e , emprunt e2 
 where e2.date_retour< 'now'  and e2.date_retourf is null 
 and e.id_emprunteur = e2.id_emprunteur  
 group by nom_empr 


6)	Afficher les livres qui n’ont jamais emprunté 
--q6 les livres qui non jamais été emprunter 
 select titre_livre from livre l
 except
 select titre_livre
 from emprunt e , livre l , exemplaire e2 
 where e.id_exemplaire = e2.id_exemplaire 
 and e2.isbm = l.isbm 
 group by titre_livre



## 7)	Afficher les emprunteurs qui ont emprunté le maximum de livres 
-- q7 afficher les emprunteurs qui ont emprunté le max de livres
SELECT e2.*, COUNT(DISTINCT e.id_exemplaire) AS nombre_livres
FROM emprunt e, emprunteur e2
WHERE e.id_emprunteur = e2.id_emprunteur
GROUP BY e2.id_emprunteur
HAVING COUNT(DISTINCT e.id_exemplaire) = (
    SELECT COUNT(DISTINCT e.id_exemplaire) AS max_nombre_livres
    FROM emprunt e
    GROUP BY e.id_emprunteur
    ORDER BY max_nombre_livres desc
    limit 1 );


## 8)	Afficher l’exemplaire le plus cher pour chaque livre 
-- q8 affichage l'exemplaire le plus cher pour chaque livre 
SELECT e.isbm, e.id_exemplaire,titre_livre , e.valeur_remplacement
FROM exemplaire e , livre l 
WHERE l.isbm = e.isbm  and (e.isbm, e.valeur_remplacement) IN (
    SELECT isbm, MAX(valeur_remplacement)
    FROM exemplaire
    GROUP BY isbm);



## 9)	Vider le contenue de toutes les tables 
--q9 vider de toutes les tables
  
delete from exemplaire  ;
delete from editeur;
delete from emprunteur ;


## 10)	Supprimer la base de donnée « Biblio »
drop database Biblio ;


