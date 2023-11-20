USE moviesite;

-- user_favorites_movie_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the
-- `user_favorites_movie` table in the `moviesite` database.
-- It includes operations for managing user favorite movies and retrieving
-- favorite movie information.

DROP PROCEDURE IF EXISTS favorite_movie;
DELIMITER //
-- Procedure: favorite_movie
-- Description: Adds a movie to a user's list of favorites.
-- Parameters:
--   username (VARCHAR(64)): The username of the user who is favoriting the movie.
--   movieId (INT): The ID of the movie being favorited.
CREATE PROCEDURE favorite_movie(IN username_p VARCHAR(64), IN movie_id_p INT)
BEGIN
  INSERT INTO user_favorites_movie (username, movie_id) VALUES (username_p, movie_id_p);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS unfavorite_movie;
DELIMITER //
-- Procedure: unfavorite_movie
-- Description: Removes a movie from a user's list of favorites.
-- Parameters:
--   userId (INT): The ID of the user who is unfavoriting the movie.
--   movieId (INT): The ID of the movie being unfavorited.
CREATE PROCEDURE unfavorite_movie(IN username_p VARCHAR(64), IN movie_id_p INT)
BEGIN
  DELETE FROM user_favorites_movie WHERE username = username_p AND movie_id = movie_id_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_favorite_movies;
DELIMITER //
-- Function: get_favorite_movies
-- Description: Retrieves a list of a user's favorite movies.
-- Parameters:
--   username (VARCHAR): The ID of the user whose favorite movies are to be retrieved.
CREATE PROCEDURE get_favorite_movies(username_p VARCHAR(64)) 
BEGIN
SELECT movies.* 
	FROM user_favorites_movie JOIN movies
		USING (movie_id)
	WHERE username = username_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_favoriting_users;
DELIMITER //
-- Function: get_favoriting_users
-- Description: Retrieves a list of users who have favorited supplied movie
-- Parameters:
--   movie_id_p (INT): The ID of the movie in question.
CREATE PROCEDURE get_favoriting_users(movie_id_p INT)
BEGIN
SELECT users.* 
	FROM user_favorites_movie JOIN users
		USING (username)
	WHERE movie_id = movie_id_p;
END //
DELIMITER ;
