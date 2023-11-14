-- movies_table_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the `movies`
-- table in the `moviesite` database.
-- It includes operations for adding, updating, and deleting movies,
-- retrieving movie details, and ensuring data integrity.

DROP PROCEDURE IF EXISTS add_movie;
DELIMITER //
-- Procedure: add_movie
-- Description: Inserts a new movie into the `movies` table.
-- Parameters:
--   movieTitle (VARCHAR(1000)): The title of the movie.
--   tmdbId (VARCHAR(255)): The TMDB (The Movie Database) ID of the movie.
CREATE PROCEDURE add_movie(IN movie_title VARCHAR(1000), IN tmdbId VARCHAR(255))
BEGIN
  INSERT INTO movies (title, tmdb_id) VALUES (movie_title, tmdbId);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_movie;
DELIMITER //
-- Procedure: update_movie
-- Description: Updates details of an existing movie in the `movies` table.
-- Parameters:
--   movie_id_p (INT): The ID of the movie to update.
--   new_title_p (VARCHAR(1000)): The new title of the movie.
--   newTmdbId (VARCHAR(255)): The new TMDB ID of the movie.
CREATE PROCEDURE update_movie(IN movie_id_p INT, 
							  IN new_title_p VARCHAR(1000), 
                              IN newTmdbId VARCHAR(255))
BEGIN
  UPDATE movies SET title = new_title_p, tmdb_id = newTmdbId WHERE movie_id = movie_id_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_movie;
DELIMITER //

-- Procedure: delete_movie
-- Description: Deletes a movie from the `movies` table.
-- Parameters:
--   movie_id_p (INT): The ID of the movie to delete.
CREATE PROCEDURE delete_movie(IN movie_id_p INT)
BEGIN
  DELETE FROM movie_has_genre WHERE movie_id = movie_id_p;
  DELETE FROM user_favorites_movie WHERE movie_id = movie_id_p;
  DELETE FROM movies WHERE movie_id = movie_id_p;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS get_movie;
DELIMITER //
-- Function: get_movie
-- Description: Retrieves movie details based on a search term that matches title
-- Parameters:
--   search_term (VARCHAR(1000)): The term used to search for the movie.
-- Returns: A table containing movies that match the search term.
CREATE FUNCTION get_movie(search_term VARCHAR(1000))
RETURNS TABLE
RETURN SELECT * FROM movies
       WHERE title LIKE CONCAT('%', search_term, '%')
DELIMITER ;
