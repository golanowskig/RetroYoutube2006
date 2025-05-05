-- Create procedure

CREATE OR ALTER PROCEDURE review_procedure
	@RevUsuari NVARCHAR(255), --El raul diu que puc posar el mateix tipo que a les taules, perquè de moment no faré control d'errors, però ho deixo així.
	@RevVideo NVARCHAR(255),
	@RevRating NVARCHAR(255)

AS
BEGIN
	BEGIN TRANSACTION

		IF ISNUMERIC(@RevUsuari) = 0
		BEGIN	--Raise an error and print a message if @Revusuari is not numeric
			RAISERROR ('Necessites un valor numèric', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END

		IF ISNUMERIC(@RevVideo) = 0
		BEGIN	--Raise an error and print a message if @RevVideo is not numeric
			RAISERROR ('Necessites un valor numèric', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END

		IF ISNUMERIC(@RevRating) = 0
		BEGIN	--Raise an error and print a message if @RevRatingis not numeric
			RAISERROR ('Necessites un valor numèric', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END

		IF EXISTS(
			SELECT 1
			FROM Usuaris
			WHERE Usuari_ID = @RevUsuari
			) 
			AND 
			EXISTS(
			SELECT 1 
			FROM Videos
			WHERE Video_ID = @RevVideo
			)
			BEGIN--Si existeix usuari i/o video que continui, si no que tiri enrere
			
			IF EXISTS( --DIVERGÈNCIA PER SI NO EXISTEIXEN ELS VALORS DONATS
				SELECT 1
				FROM Review
				WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo
				)
				BEGIN --FALTA QUE ACTUALITZI REVIEW




					UPDATE Review
					SET
					Rating = @RevRating
					WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo
				END
			IF NOT EXISTS(
				SELECT 1
				FROM Review
				WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo
				)
				BEGIN

			INSERT INTO Review (Usuari_ID_fk, Video_ID_fk, Rating)
			VALUES (@RevUsuari, @RevVideo, @RevRating)
				
				
					UPDATE Videos
					SET
					TotalRating = TotalRating + @RevRating,
					TotalVotes = TotalVotes + 1
					WHERE Video_ID = @RevVideo
				END
			END
			
	COMMIT TRANSACTION
END
GO


--Ara falta executar-la
EXEC review_procedure '2', '2', '5'







