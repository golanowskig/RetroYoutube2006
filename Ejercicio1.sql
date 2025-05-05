/*
1.Queremos crear un sistema de likes para vídeos que funcione como el sistema priginal de youtube (con hasta 5 estrellas). Queremos que este sistema lleve la cuenta de tanto los votos como de la media de votos en tiempo real de cada vídeo.

Crea las tablas que necesitaremos para este sistema.

Pon mucha atención en los tipos de los datos ya que debemos maximizar su eficiencia
Vigila: Las reviews de los usuarios pueden variar en unidades de media estrella, pero para la media queremos al menos dos decimales de precisión.
*/

--Create Database
CREATE DATABASE Youtube2006
GO

--Crear tabla Usuarios
DROP TABLE IF EXISTS Usuaris
CREATE TABLE Usuaris
(
	Usuari_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Usuari_name VARCHAR (25) UNIQUE NOT NULL,
	Creation_Date DATETIME DEFAULT GETDATE() NOT NULL
);
GO

--Crear tabla videos
DROP TABLE IF EXISTS Videos
CREATE TABLE Videos
(
	Video_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Titulos_video NVARCHAR (100) UNIQUE NOT NULL, 
	Usuari_ID_fk INT,
	CONSTRAINT usuariID_VaU FOREIGN KEY (Usuari_ID_fk) REFERENCES Usuaris(Usuari_ID),
	Upload_Date DATETIME DEFAULT GETDATE () NOT NULL,
	TotalRating INT NOT NULL DEFAULT 0,
	TotalVotes INT DEFAULT 0,
);
GO

--Crear tablas Reviews
DROP TABLE IF EXISTS Review
CREATE TABLE Review
(
	Video_ID_fk INT FOREIGN KEY REFERENCES Videos(Video_ID),	--Mateix que fer la cosntraint però més ràpid, te la crea sola el programa
	Usuari_ID_fk INT,
	CONSTRAINT usuariID_RaU FOREIGN KEY (Usuari_ID_fk) REFERENCES Usuaris(Usuari_ID),
	rATING
	Rating DECIMAL(2,1) CHECK (Rating BETWEEN 0.5 AND 5.0),
	Data_review SMALLDATETIME DEFAULT GETDATE() NOT NULL,
	PRIMARY KEY (Video_ID_fk, Usuari_ID_fk)
);
GO


