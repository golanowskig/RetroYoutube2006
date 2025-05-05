CREATE OR ALTER PROCEDURE review_procedure
    @RevUsuari NVARCHAR(255),
    @RevVideo NVARCHAR(255),
    @RevRating NVARCHAR(255)
AS
BEGIN
    BEGIN TRANSACTION

        -- Validar que los valores sean numéricos
        IF ISNUMERIC(@RevUsuari) = 0
        BEGIN
            RAISERROR ('Necessites un valor numèric per a Usuari', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END

        IF ISNUMERIC(@RevVideo) = 0
        BEGIN
            RAISERROR ('Necessites un valor numèric per a Video', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END

        IF ISNUMERIC(@RevRating) = 0
        BEGIN
            RAISERROR ('Necessites un valor numèric per a Rating', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END

        -- Verificar que Usuario y Video existen
        IF EXISTS (
            SELECT 1
            FROM Usuaris
            WHERE Usuari_ID = @RevUsuari
        ) AND EXISTS (
            SELECT 1
            FROM Videos
            WHERE Video_ID = @RevVideo
        )
        BEGIN
            -- Si la review ya existe, actualizar el rating
            IF EXISTS (
                SELECT 1
                FROM Review
                WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo
            )
            BEGIN
                DECLARE @OldRating INT;
                SELECT @OldRating = Rating
                FROM Review
                WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo;

                UPDATE Review
                SET Rating = @RevRating
                WHERE Usuari_ID_fk = @RevUsuari AND Video_ID_fk = @RevVideo;

                UPDATE Videos
                SET
                    TotalRating = TotalRating - @OldRating + @RevRating
                WHERE Video_ID = @RevVideo;
            END
            ELSE
            BEGIN
                -- Si la review no existe, crearla
                INSERT INTO Review (Usuari_ID_fk, Video_ID_fk, Rating)
                VALUES (@RevUsuari, @RevVideo, @RevRating);

                UPDATE Videos
                SET
                    TotalRating = TotalRating + @RevRating,
                    TotalVotes = TotalVotes + 1
                WHERE Video_ID = @RevVideo;
            END
        END
        ELSE
        BEGIN
            RAISERROR ('El Usuari o el Video no existeixen', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END

    COMMIT TRANSACTION
END
GO
