-- movies_table_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the `movies`
-- table in the `moviesite` database.
-- It includes operations for adding, updating, and deleting movies,
-- retrieving movie details, and ensuring data integrity.

DELIMITER //

-- Procedure: AddMovie
-- Description: Inserts a new movie into the `movies` table.
-- Parameters:
--   movieTitle (VARCHAR(1000)): The title of the movie.
--   tmdbId (VARCHAR(255)): The TMDB (The Movie Database) ID of the movie.
CREATE PROCEDURE AddMovie(IN movieTitle VARCHAR(1000), IN tmdbId VARCHAR(255))
BEGIN
  INSERT INTO movies (title, tmdb_id) VALUES (movieTitle, tmdbId);
END //
DELIMITER ;

DELIMITER //

-- Procedure: UpdateMovie
-- Description: Updates details of an existing movie in the `movies` table.
-- Parameters:
--   movieId (INT): The ID of the movie to update.
--   newTitle (VARCHAR(1000)): The new title of the movie.
--   newTmdbId (VARCHAR(255)): The new TMDB ID of the movie.
CREATE PROCEDURE UpdateMovie(IN movieId INT, IN newTitle VARCHAR(1000), IN newTmdbId VARCHAR(255))
BEGIN
  UPDATE movies SET title = newTitle, tmdb_id = newTmdbId WHERE movie_id = movieId;
END //
DELIMITER ;

DELIMITER //

-- Procedure: DeleteMovie
-- Description: Deletes a movie from the `movies` table.
-- Parameters:
--   movieId (INT): The ID of the movie to delete.
CREATE PROCEDURE DeleteMovie(IN movieId INT)
BEGIN
  DELETE FROM movies WHERE movie_id = movieId;
END //
DELIMITER ;

DELIMITER //

-- Function: GetMovie
-- Description: Retrieves movie details based on a search term that can match
-- either the title or TMDB ID.
-- Parameters:
--   searchTerm (VARCHAR(1000)): The term used to search for the movie.
-- Returns: A table containing movies that match the search term.
CREATE FUNCTION GetMovie(searchTerm VARCHAR(1000))
RETURNS TABLE
RETURN SELECT * FROM movies
       WHERE title LIKE CONCAT('%', searchTerm, '%')
          OR tmdb_id LIKE CONCAT('%', searchTerm, '%');
DELIMITER ;

DELIMITER //

-- Trigger: BeforeInsertMovie
-- Description: Validates data before inserting a new movie. Ensures that the
-- TMDB ID is unique.
CREATE TRIGGER BeforeInsertMovie
BEFORE INSERT ON movies
FOR EACH ROW
BEGIN
  DECLARE existingTmdbIdCount INT;
  SELECT COUNT(*) INTO existingTmdbIdCount FROM movies WHERE tmdb_id = NEW.tmdb_id;
  IF existingTmdbIdCount > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate tmdb_id detected';
  END IF;
END //
DELIMITER ;

DELIMITER //

-- Trigger: BeforeDeleteMovie
-- Description: Checks for dependencies before deleting a movie. Ensures no
-- reviews are associated with the movie.
CREATE TRIGGER BeforeDeleteMovie
BEFORE DELETE ON movies
FOR EACH ROW
BEGIN
  DECLARE reviewCount INT;
  SELECT COUNT(*) INTO reviewCount FROM reviews WHERE movie_id = OLD.movie_id;
  IF reviewCount > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete movie with existing reviews';
  END IF;
END //
DELIMITER ;
