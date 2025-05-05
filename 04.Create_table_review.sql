--Crear tablas Reviews
DROP TABLE IF EXISTS Review
CREATE TABLE Review
(
	Video_ID_fk INT FOREIGN KEY REFERENCES Videos(Video_ID),	--Mateix que fer la constraint però més ràpid, te la crea sola el programa
	Usuari_ID_fk INT,
	CONSTRAINT usuariID_RaU FOREIGN KEY (Usuari_ID_fk) REFERENCES Usuaris(Usuari_ID),
	Rating TINYINT CHECK (Rating BETWEEN 1.0 AND 10.0),
	Data_review SMALLDATETIME DEFAULT GETDATE() NOT NULL,
	PRIMARY KEY (Video_ID_fk, Usuari_ID_fk)
);
GO