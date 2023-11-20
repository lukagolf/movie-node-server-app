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
CREATE PROCEDURE add_movie(movie_title VARCHAR(1000), 
						   movie_release DATE,
                           movie_summary VARCHAR(5000),
                           movie_photo_url VARCHAR(10000))
BEGIN
  INSERT INTO movies (title, release_date, summary, photo_url) 
	VALUES (movie_title, movie_release, movie_summary, movie_photo_url);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_movie;
DELIMITER //
-- Procedure: update_movie
-- Description: Updates details of an existing movie in the `movies` table.
-- Parameters:
--   movie_id_p (INT): The ID of the movie to update.
--   new_release (DATETIME): updated date of movie to update
--   new_title (VARCHAR(1000)): The new title of the movie.
--   new_summary (VARCHAR(255)): The new summary of the movie
--   new_photo_url (VARCHAR(100000): New url for movie photo
CREATE PROCEDURE update_movie(movie_id_p INT,
                              new_title VARCHAR(1000), 
                              new_release DATE,
							  new_summary VARCHAR(5000),
							  new_photo_url VARCHAR(10000))
BEGIN
  UPDATE movies SET title = new_title, 
					release_date = new_release,
                    summary = new_summary,
                    new_photo_url = new_photo_url
  WHERE movie_id = movie_id_p;
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

DROP PROCEDURE IF EXISTS get_movies_by_title;
DELIMITER //
-- Procedure: get_movies_by_title
-- Description: Retrieves movie details based on a search term that matches title
-- Parameters:
--   search_term (VARCHAR(1000)): The term used to search for the movie.
CREATE PROCEDURE get_movies_by_title(search_term VARCHAR(1000))
BEGIN
SELECT * FROM movies
       WHERE title LIKE CONCAT('%', search_term, '%');
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_all_movies;
DELIMITER //
-- Procedure: get_all_movies
-- Description: Retrieves all movies in DB
CREATE PROCEDURE get_all_movies()
BEGIN
SELECT * FROM movies;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_movie;
DELIMITER //
-- Procedure: get_movie
-- Description: Retrieve a specific movie in DB
-- Parameters:
--   id_p (INT): ID of desired movie
CREATE PROCEDURE get_movie(id_p INT)
BEGIN
SELECT * FROM movies
	WHERE movie_id = id_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_favorite_movies;
DELIMITER //
-- Procedure: get_favorited_movie
-- Description: get a list of a user's favorite movies 
-- Parameters:
--   username (VARCHAR): ID of desired movie