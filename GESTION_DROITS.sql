/*
SUPPRESION DES VUES
*/
DROP VIEW TICKET CASCADE CONSTRAINTS;
DROP VIEW USER_INFO CASCADE CONSTRAINTS;
DROP VIEW MP_USER CASCADE CONSTRAINTS;
DROP VIEW CONNEXION_USER CASCADE CONSTRAINTS;
DROP VIEW ADRESSE_USER CASCADE CONSTRAINTS;
DROP VIEW PANIER_USER CASCADE CONSTRAINTS;
DROP VIEW USER_SOUHAIT CASCADE CONSTRAINTS;
DROP VIEW USER_PRODUIT_SOUHAIT CASCADE CONSTRAINTS;
DROP VIEW LIST_LISTE_SOUHAITS CASCADE CONSTRAINTS;
DROP VIEW USER_COMMANDE CASCADE CONSTRAINTS;
DROP VIEW USER_COMMANDE_PRODUIT CASCADE CONSTRAINTS;
DROP VIEW USER_CMD_TRANSPORTEUR CASCADE CONSTRAINTS;
DROP VIEW USER_CMD_RELAIS CASCADE CONSTRAINTS;
DROP VIEW COMMANDE_VENDEUR CASCADE CONSTRAINTS;
DROP VIEW PRODUIT_VENDEUR CASCADE CONSTRAINTS;
DROP VIEW USER_AVIS CASCADE CONSTRAINTS;
DROP VIEW USER_QUESTION CASCADE CONSTRAINTS;
DROP VIEW USER_REPONSE CASCADE CONSTRAINTS;
DROP VIEW TICKET_MOD CASCADE CONSTRAINTS;
DROP VIEW AVIS_VENDEUR CASCADE CONSTRAINTS;
DROP VIEW STAT_PRODUIT CASCADE CONSTRAINTS;
DROP VIEW TANSPORTEUR_COMMANDE CASCADE CONSTRAINTS;
DROP VIEW RELAIS_COMMANDE CASCADE CONSTRAINTS;

/* CREATE ROLE users;
CREATE ROLE invites;
CREATE ROLE vendeurs;
CREATE ROLE moderateurs;
CREATE ROLE transporteurs;
CREATE ROLE point_relais;*/

/*ebarker = user
etude 223 = vendeurs
etude 224 = moderateurs
etude 225 = transporteurs
etude 221 = point relais
etude 222 = invites*/

/* Autorisations générales */
GRANT SELECT ON CATEGORIE TO PUBLIC;
GRANT SELECT ON PRODUIT TO PUBLIC;
GRANT SELECT ON VENDEUR TO PUBLIC;
GRANT SELECT ON AVIS TO PUBLIC;
GRANT SELECT ON QUESTION TO PUBLIC;
GRANT SELECT ON REPONSE TO PUBLIC;
GRANT SELECT ON POINT_RELAIS TO PUBLIC;
GRANT SELECT ON NOTE_AVIS TO PUBLIC;
GRANT SELECT ON REPONSE_AVIS TO PUBLIC;

/* UTILISATEUR */
/* Autorise à l'utilisateur de voir et modifier seulement son profil */
CREATE VIEW USER_INFO AS
    SELECT *
    FROM UTILISATEUR
    WHERE login=USER;
GRANT SELECT ON USER_INFO TO EBARKER;
GRANT UPDATE(email,telephone,photo,nom,prenom,date_naissance,langue,pays,piece_identite) ON USER_INFO TO EBARKER;

/* Autorise à l'utilisateur de voir, modifier et ajouter seulement ses moyens de payement */
CREATE VIEW MP_USER AS
    SELECT ID_CARTE, NOM_PRENOM, NUMERO, DATE_EXP, CRYPTOGRAMME, TYPE_CARTE
    FROM MOYEN_PAYEMENT
    WHERE utilisateur=USER;
GRANT SELECT ON MP_USER TO EBARKER;
GRANT INSERT ON MP_USER TO EBARKER;
GRANT UPDATE ON MP_USER TO EBARKER;

/* Autorise à l'utilisateur de voir seulement ses connexions */
CREATE VIEW CONNEXION_USER AS
    SELECT *
    FROM CONNEXION
    WHERE utilisateur=USER;
GRANT SELECT ON CONNEXION_USER TO EBARKER;

/* Autorise à l'utilisateur de voir, modifier et ajouter seulement ses adressses postales */
CREATE VIEW ADRESSE_USER AS
    SELECT ID_ADRESSE, NOM, PRENOM, NUMERO, RUE, CODE_POSTAL, VILLE, PAYS, INFORMATIONS_SUPPLEMENTAIRES
    FROM ADRESSE_POSTALE
    WHERE utilisateur=USER;
GRANT SELECT ON ADRESSE_USER TO EBARKER;
GRANT INSERT ON ADRESSE_USER TO EBARKER;
GRANT UPDATE ON MP_USER TO EBARKER;

/* Autorise à l'utilisateur de voir seulement son panier */
CREATE VIEW PANIER_USER AS
    SELECT *
    FROM PANIER
    WHERE utilisateur=USER;
GRANT SELECT ON PANIER_USER TO EBARKER;

/* Autorise à l'utilisateur de voir seulement ses listes de souhaits */
CREATE VIEW USER_SOUHAIT AS
    SELECT *
    FROM LISTE_SOUHAITS
    WHERE id_list IN
      (SELECT liste_souhait FROM SOUHAIT_UTILISATEUR WHERE utilisateur=USER
      );
GRANT SELECT ON USER_SOUHAIT TO EBARKER;

/* Autorise à l'utilisateur de voir, ajouter et supprimer seulement les produits de ses listes de souhaits */
CREATE VIEW USER_PRODUIT_SOUHAIT AS
    SELECT *
    FROM SOUHAIT_PRODUIT
    WHERE liste_souhait IN (SELECT id_list FROM USER_SOUHAIT);
GRANT SELECT ON USER_PRODUIT_SOUHAIT TO EBARKER;
GRANT INSERT ON USER_PRODUIT_SOUHAIT TO EBARKER;
GRANT DELETE ON USER_PRODUIT_SOUHAIT TO EBARKER;

/* Autorise à l'utilisateur de voir seulement des utilisateurs à ses listes de souhaits */
CREATE VIEW LIST_LISTE_SOUHAITS AS
    SELECT * FROM SOUHAIT_UTILISATEUR WHERE liste_souhait IN (SELECT liste_souhait FROM SOUHAIT_UTILISATEUR WHERE UTILISATEUR=USER);
GRANT SELECT ON LIST_LISTE_SOUHAITS TO EBARKER;

/* Autorise à l'utilisateur de voir seulement ses tickets */
CREATE VIEW TICKET AS
    SELECT * FROM SUPPORT WHERE utilisateur=USER;
GRANT SELECT ON TICKET TO EBARKER;

/* Autorise à l'utilisateur de voir seulement ses commandes */
CREATE VIEW USER_COMMANDE AS
    SELECT *
    FROM COMMANDE
    WHERE panier IN
      (SELECT id_panier FROM PANIER WHERE utilisateur=USER
      );
GRANT SELECT ON USER_COMMANDE TO EBARKER;

/* Autorise à l'utilisateur de voir seulement les porduits de ses commandes */


CREATE VIEW USER_COMMANDE_PRODUIT AS
    SELECT id_commande,id_produit
    FROM COMMANDE
    JOIN PANIER ON PANIER.id_panier=COMMANDE.panier
    JOIN PANIER_PRODUIT ON PANIER_PRODUIT.id_panier=PANIER.id_panier
    WHERE utilisateur=USER;
GRANT SELECT ON USER_COMMANDE_PRODUIT TO EBARKER;

/* Autorise à l'utilisateur de voir seulement les transporteurs de ses commandes */
CREATE VIEW USER_CMD_TRANSPORTEUR AS
    SELECT *
    FROM COMMANDE_TRANSPORTEUR
    WHERE commande IN
      (SELECT id_commande
      FROM COMMANDE
      WHERE panier IN
        (SELECT id_panier FROM PANIER WHERE utilisateur=USER
        )
      );
GRANT SELECT ON USER_CMD_TRANSPORTEUR TO EBARKER;

/* Autorise à l'utilisateur de voir seulement les points relais de ses commandes */
CREATE VIEW USER_CMD_RELAIS AS
    SELECT *
    FROM COMMANDE_POINT_RELAIS
    WHERE commande IN
      (SELECT id_commande
      FROM COMMANDE
      WHERE panier IN
        (SELECT id_panier FROM PANIER WHERE utilisateur=USER
        )
      );
GRANT SELECT ON USER_CMD_RELAIS TO EBARKER;


/* Autorise à l'utilisateur d'écrire et modifier ses avis */
CREATE VIEW USER_AVIS AS
    SELECT titre,description,note,produit
    FROM AVIS;
GRANT INSERT ON USER_AVIS TO EBARKER;
GRANT UPDATE(titre,description,note) ON USER_AVIS TO EBARKER;

/* Autorise à l'utilisateur d'écrire et modifier ses questions */
CREATE VIEW USER_QUESTION AS
    SELECT titre,description,produit
    FROM QUESTION;
GRANT INSERT ON USER_QUESTION TO EBARKER;
GRANT UPDATE(titre,description) ON USER_QUESTION TO EBARKER;

/* Autorise à l'utilisateur d'écrire et modifier ses réponses */
CREATE VIEW USER_REPONSE AS
    SELECT message,question
    FROM REPONSE;
GRANT INSERT ON USER_REPONSE TO EBARKER;
GRANT UPDATE(message) ON USER_REPONSE TO EBARKER;

/*
Des TRIGGERS seront nécessaires pour pouvoir supprimer et ajouter des utilisateurs à une liste de souhait où nous sommes
ainsi que pour ajouter et supprimer des produits dans notre panier.
Il en faudra un ausssi pour créer une commande relier seulement à nos paniers.
*/


/* MODERATEUR */
/* Autoritsation aux modérateurs de voir les profils */
GRANT SELECT ON UTILISATEUR TO ETUDE224;

/* Autoritsation aux modérateurs de supprimer des photos */
GRANT DELETE ON PHOTO TO ETUDE224;
  
/* Autoritsation aux modérateurs de lire,écrire des tickets */
GRANT SELECT ON SUPPORT TO ETUDE224;
CREATE VIEW TICKET_MOD AS
    SELECT message,ticket_parent
    FROM SUPPORT;
GRANT INSERT ON TICKET_MOD TO ETUDE224;

/* Autorise les modérateurs à "supprimer" des avis, question, reponse */
GRANT UPDATE(description) ON AVIS TO ETUDE224;
GRANT UPDATE(description) ON QUESTION TO ETUDE224;
GRANT UPDATE(message) ON REPONSE TO ETUDE224;

/* Autorise les modérateurs à supprimer des notes sur les avis */
GRANT DELETE ON NOTE_AVIS TO ETUDE224;

/* Autorise les modérateurs à lire les commandes */
GRANT SELECT ON COMMANDE TO ETUDE224;

/* Autorise les modérateurs à rajouter un code promo aux paniers */
GRANT UPDATE(code_promo) ON PANIER TO ETUDE224;


/* VENDEUR */
/* Autorise les vendeurs à voir les commandes de leurs produits */

CREATE VIEW COMMANDE_VENDEUR AS
  (SELECT id_commande,date_commande,informations_supplementaires,cadeau,adresse_postale,titre AS titre_produit
    FROM COMMANDE
    JOIN PANIER_PRODUIT ON PANIER_PRODUIT.id_panier=COMMANDE.panier
    JOIN PRODUIT ON PRODUIT.id_produit=PANIER_PRODUIT.id_produit
    WHERE vendeur=USER
  );
GRANT SELECT ON COMMANDE_VENDEUR TO ETUDE223;

/* Autorise les vendeurs à ajouter et modifier ses produits */
CREATE VIEW PRODUIT_VENDEUR AS
    SELECT titre,description,prix,nationalite,type,poids,taille,caracteristiques,quantite
    FROM PRODUIT
    WHERE vendeur=USER;
GRANT INSERT ON PRODUIT_VENDEUR TO ETUDE223;
GRANT UPDATE ON PRODUIT_VENDEUR TO ETUDE223;

/* Autorise les vendeurs à ajouter des commentaires aux avis de leurs produits */

CREATE VIEW AVIS_VENDEUR AS
    SELECT texte
    FROM REPONSE_AVIS
    WHERE avis IN (SELECT id_avis
                    FROM AVIS
                    WHERE produit IN (SELECT id_produit
                                        FROM PRODUIT
                                        WHERE vendeur=USER));
GRANT INSERT ON AVIS_VENDEUR TO ETUDE223;

/* Autorise les vendeurs à voir les stats de visionnage de leurs produits */

CREATE VIEW STAT_PRODUIT AS
    SELECT produit, COUNT(id_visionnage) AS NBVUES
    FROM VISIONNAGE
    WHERE produit IN (SELECT id_produit FROM PRODUIT WHERE vendeur=USER)
    GROUP BY produit;
GRANT SELECT ON STAT_PRODUIT TO ETUDE223;


/* TRANSPORTEUR */
/* Autorise les transporteurs de voir les commandes liés */



CREATE VIEW TANSPORTEUR_COMMANDE AS
    SELECT commande,adresse_postale,produit
    FROM COMMANDE_TRANSPORTEUR
    JOIN COMMANDE ON COMMANDE.id_commande=COMMANDE_TRANSPORTEUR.commande
    JOIN PANIER ON PANIER.id_panier=COMMANDE.panier
    JOIN PANIER_PRODUIT ON PANIER_PRODUIT.id_panier=PANIER.id_panier
    WHERE transporteur=USER;
GRANT SELECT ON TANSPORTEUR_COMMANDE TO ETUDE225;


/* POINTS RELAIS */
/* Autorise les points relais à voir les commandes liés */
CREATE VIEW RELAIS_COMMANDE AS
    SELECT commande,produit,nom,prenom
    FROM COMMANDE_POINT_RELAIS
    JOIN COMMANDE ON COMMANDE.id_commande=COMMANDE_POINT_RELAIS.commande
    JOIN PANIER ON PANIER.id_panier=COMMANDE.panier
    JOIN PANIER_PRODUIT ON PANIER_PRODUIT.id_panier=PANIER.id_panier
    JOIN UTILISATEUR ON UTILISATEUR.login=PANIER.utilisateur
    WHERE point_relais=USER;
GRANT SELECT ON RELAIS_COMMANDE TO ETUDE221;