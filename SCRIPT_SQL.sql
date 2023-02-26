/*
SUPPRESION DES TABLES
*/
DROP TABLE UTILISATEUR CASCADE CONSTRAINTS;
DROP TABLE ANONYME CASCADE CONSTRAINTS;
DROP TABLE SUPPORT CASCADE CONSTRAINTS;
DROP TABLE MOYEN_PAYEMENT CASCADE CONSTRAINTS;
DROP TABLE CONNEXION CASCADE CONSTRAINTS;
DROP TABLE VENDEUR CASCADE CONSTRAINTS;
DROP TABLE PRODUIT CASCADE CONSTRAINTS;
DROP TABLE VISIONNAGE CASCADE CONSTRAINTS;
DROP TABLE ADRESSE_POSTALE CASCADE CONSTRAINTS;
DROP TABLE CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE CENTRE_LOGISTIQUE CASCADE CONSTRAINTS;
DROP TABLE AVIS CASCADE CONSTRAINTS;
DROP TABLE REPONSE_AVIS CASCADE CONSTRAINTS;
DROP TABLE PHOTO CASCADE CONSTRAINTS;
DROP TABLE QUESTION CASCADE CONSTRAINTS;
DROP TABLE REPONSE CASCADE CONSTRAINTS;
DROP TABLE PANIER CASCADE CONSTRAINTS;
DROP TABLE LISTE_SOUHAITS CASCADE CONSTRAINTS;
DROP TABLE POINT_RELAIS CASCADE CONSTRAINTS;
DROP TABLE TRANSPORTEUR CASCADE CONSTRAINTS;
DROP TABLE COMMANDE CASCADE CONSTRAINTS;
DROP TABLE PRODUIT_CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE PRODUIT_CENTRELOG CASCADE CONSTRAINTS;
DROP TABLE NOTE_AVIS CASCADE CONSTRAINTS;
DROP TABLE SOUHAIT_UTILISATEUR CASCADE CONSTRAINTS;
DROP TABLE SOUHAIT_PRODUIT CASCADE CONSTRAINTS;
DROP TABLE COMMANDE_TRANSPORTEUR CASCADE CONSTRAINTS;
DROP TABLE COMMANDE_POINT_RELAIS CASCADE CONSTRAINTS;
DROP TABLE PANIER_PRODUIT CASCADE CONSTRAINTS;
/*
CREATION DES TABLES
*/
CREATE TABLE UTILISATEUR
  (
    login     VARCHAR(40) PRIMARY KEY,
    email     VARCHAR(60) NOT NULL UNIQUE CHECK(email LIKE '%_@_%.__%'),
    telephone VARCHAR(20),
    photo BLOB,
    nom            VARCHAR(50) NOT NULL,
    prenom         VARCHAR(50) NOT NULL,
    date_naissance DATE,
    langue         VARCHAR(20) DEFAULT 'English',
    pays           VARCHAR(20) NOT NULL,
    piece_identite BLOB,
    moderateur CHAR(1) DEFAULT '0'
  );
CREATE TABLE ANONYME
  (
    ip                 VARCHAR(15) PRIMARY KEY,
    deniere_connexion DATE DEFAULT CURRENT_DATE,
    appareil           VARCHAR(40),
    utilisateur        VARCHAR(40) REFERENCES UTILISATEUR(login)
  );
CREATE TABLE SUPPORT
  (
    id_support INT PRIMARY KEY,
    sdate      DATE DEFAULT CURRENT_DATE NOT NULL,
    MESSAGE CLOB NOT NULL,
    utilisateur   VARCHAR(40) REFERENCES UTILISATEUR(login),
    ticket_parent INT REFERENCES SUPPORT(id_support)
  );
CREATE TABLE MOYEN_PAYEMENT
  (
    id_carte     INT PRIMARY KEY,
    nom_prenom   VARCHAR(100) NOT NULL,
    numero       VARCHAR(16) NOT NULL,
    date_exp     VARCHAR(5) NOT NULL CHECK( date_exp LIKE '__/__'),
    cryptogramme VARCHAR(4) NOT NULL,
    type_carte   VARCHAR(20) DEFAULT 'Carte Bancaire',
    utilisateur  VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login) 
  );
CREATE TABLE CONNEXION
  (
    id_connexion INT PRIMARY KEY,
    ip           VARCHAR(15) NOT NULL,
    appareil     VARCHAR(40),
    cdate        DATE DEFAULT CURRENT_DATE,
    localisation CLOB NOT NULL,
    utilisateur VARCHAR(40) REFERENCES UTILISATEUR(login) NOT NULL
  );
CREATE TABLE VENDEUR
  (
    id_vendeur varchar(40) PRIMARY KEY,
    email      VARCHAR(60) NOT NULL UNIQUE CHECK(email LIKE '%_@_%.__%'),
    telephone  VARCHAR(20),
    photo BLOB,
    langue     VARCHAR(20) DEFAULT 'English',
    pays       VARCHAR(20) NOT NULL,
    entreprise VARCHAR(50) NOT NULL UNIQUE
  );
CREATE TABLE PRODUIT
  (
    id_produit INT PRIMARY KEY,
    titre      VARCHAR(30) NOT NULL,
    description CLOB NOT NULL,
    prix        FLOAT(2) DEFAULT 0,
    nationalite VARCHAR(20) DEFAULT 'English',
    type        VARCHAR(20), /* Matériel / code de jeu / ... */
    poids       FLOAT(2),
    taille      FLOAT(2),
    caracteristiques CLOB NOT NULL,
    quantite INT,
    vendeur varchar(40) DEFAULT USER REFERENCES VENDEUR(id_vendeur)
  );
CREATE TABLE VISIONNAGE
  (
    id_visionnage INT PRIMARY KEY,
    vdate         DATE DEFAULT CURRENT_DATE,
    contexte      VARCHAR(20),
    duree         VARCHAR(10),
    utilisateur   VARCHAR(40) REFERENCES UTILISATEUR(login),
    anonyme       VARCHAR(15) REFERENCES ANONYME(ip),
    produit       INT REFERENCES PRODUIT(id_produit) NOT NULL
  );
CREATE TABLE ADRESSE_POSTALE
  (
    id_adresse  INT PRIMARY KEY,
    nom         VARCHAR(50) NOT NULL,
    prenom      VARCHAR(50) NOT NULL,
    numero      VARCHAR(10) NOT NULL,
    rue         VARCHAR(50) NOT NULL,
    code_postal INT NOT NULL,
    ville       VARCHAR(50) NOT NULL,
    pays        VARCHAR(20) NOT NULL,
    informations_supplementaires CLOB,
    utilisateur VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login)
  );
CREATE TABLE CATEGORIE
  (
    nom_categorie    VARCHAR(30) PRIMARY KEY,
    type             VARCHAR(20) NOT NULL,
    categorie_parent VARCHAR(30) REFERENCES CATEGORIE(nom_categorie)
  );
CREATE TABLE CENTRE_LOGISTIQUE
  (
    id_centrelog INT PRIMARY KEY,
    nom          VARCHAR(30) NOT NULL,
    numero       VARCHAR(10) NOT NULL,
    rue          VARCHAR(50) NOT NULL,
    code_postal  INT NOT NULL,
    ville        VARCHAR(50) NOT NULL,
    pays         VARCHAR(20) NOT NULL
  );
CREATE TABLE AVIS
  (
    id_avis INT PRIMARY KEY,
    titre   VARCHAR(30) NOT NULL,
    description CLOB NOT NULL,
    adate       DATE DEFAULT CURRENT_DATE,
    note        INT DEFAULT 5 CHECK(note BETWEEN 1 AND 5),
    utilisateur VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login),
    produit     INT REFERENCES PRODUIT(id_produit) NOT NULL
  );
  
CREATE TABLE REPONSE_AVIS
(
  id_reponse_avis INT PRIMARY KEY,
  texte clob not null,
  radate DATE DEFAULT CURRENT_DATE,
  avis INT REFERENCES AVIS(id_avis) NOT NULL, 
  vendeur varchar(40) DEFAULT USER REFERENCES VENDEUR(id_vendeur)
);
CREATE TABLE PHOTO
  (
    id_photo INT PRIMARY KEY,
    titre    VARCHAR(30),
    description CLOB,
    produit INT REFERENCES PRODUIT(id_produit),
    avis    INT REFERENCES AVIS(id_avis)
  );
CREATE TABLE QUESTION
  (
    id_question INT PRIMARY KEY,
    titre       VARCHAR(128) NOT NULL,
    description CLOB NOT NULL,
    date_question DATE DEFAULT CURRENT_DATE NOT NULL,
    utilisateur   VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login),
    produit       INT NOT NULL REFERENCES PRODUIT(id_produit)
  );
CREATE TABLE REPONSE
  (
    id_reponse INT PRIMARY KEY,
    MESSAGE CLOB NOT NULL,
    date_reponse DATE DEFAULT CURRENT_DATE NOT NULL,
    question     INT NOT NULL REFERENCES QUESTION(id_question),
    utilisateur  VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login)
  );
CREATE TABLE PANIER
  (
    id_panier   INT PRIMARY KEY,
    code_promo  VARCHAR(20),
    utilisateur VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login)
  );
CREATE TABLE LISTE_SOUHAITS
  (
    id_list INT PRIMARY KEY,
    titre   VARCHAR(128) NOT NULL,
    descrption CLOB NOT NULL
  );
CREATE TABLE POINT_RELAIS
  (
    id_prelais  INT PRIMARY KEY,
    nom         VARCHAR(30) NOT NULL,
    numero      VARCHAR(10) NOT NULL,
    rue         VARCHAR(50) NOT NULL,
    code_postal INT NOT NULL,
    ville       VARCHAR(50) NOT NULL,
    pays        VARCHAR(20) NOT NULL,
    informations_supplementaires CLOB
  );
CREATE TABLE TRANSPORTEUR
  (
    id_transporteur INT PRIMARY KEY,
    entreprise      VARCHAR(30) NOT NULL,
    pays            VARCHAR(30) NOT NULL
  );
CREATE TABLE COMMANDE
  (
    id_commande   INT PRIMARY KEY,
    date_commande DATE DEFAULT CURRENT_DATE NOT NULL,
    informations_supplementaires CLOB,
    cadeau          CHAR(1) DEFAULT '0' NOT NULL,
    adresse_postale INT NOT NULL REFERENCES ADRESSE_POSTALE(id_adresse),
    panier          INT NOT NULL REFERENCES PANIER(id_panier)
  );
CREATE TABLE PRODUIT_CATEGORIE
  (
    produit   INT REFERENCES PRODUIT(id_produit),
    categorie VARCHAR(30) REFERENCES CATEGORIE(nom_categorie),
    PRIMARY KEY(produit, categorie)
  );
CREATE TABLE PRODUIT_CENTRELOG
  (
    produit   INT REFERENCES PRODUIT(id_produit),
    centrelog INT REFERENCES CENTRE_LOGISTIQUE(id_centrelog),
    quantite  INT NOT NULL,
    PRIMARY KEY(produit, centrelog)
  );
CREATE TABLE NOTE_AVIS
  (
    avis        INT REFERENCES AVIS(id_avis),
    utilisateur VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login),
    valeur      CHAR(1) NOT NULL,
    PRIMARY KEY(avis, utilisateur)
  );
CREATE TABLE SOUHAIT_UTILISATEUR
  (
    liste_souhait INT REFERENCES LISTE_SOUHAITS(id_list),
    utilisateur   VARCHAR(40) DEFAULT USER REFERENCES UTILISATEUR(login),
    PRIMARY KEY(liste_souhait, utilisateur)
  );
CREATE TABLE SOUHAIT_PRODUIT
  (
    liste_souhait INT REFERENCES LISTE_SOUHAITS(id_list),
    produit       INT NOT NULL REFERENCES PRODUIT(id_produit),
    PRIMARY KEY(liste_souhait, produit)
  );
CREATE TABLE COMMANDE_TRANSPORTEUR
  (
    commande     INT REFERENCES COMMANDE(id_commande),
    transporteur INT REFERENCES TRANSPORTEUR(id_transporteur),
    produit      INT REFERENCES PRODUIT(id_produit),
    PRIMARY KEY(commande, transporteur, produit)
  );
CREATE TABLE COMMANDE_POINT_RELAIS
  (
    commande     INT REFERENCES COMMANDE(id_commande),
    point_relais INT REFERENCES POINT_RELAIS(id_prelais),
    produit      INT REFERENCES PRODUIT(id_produit),
    PRIMARY KEY(commande, point_relais, produit)
  );
CREATE TABLE PANIER_PRODUIT
  (
    id_panier  INT REFERENCES PANIER(id_panier),
    id_produit INT REFERENCES PRODUIT(id_produit),
    PRIMARY KEY(id_panier, id_produit)
  );
  
/* 
MISE A JOUR :

Ajoute de DEFAULT USER dans les clés étrangères de vendeur.
*/