-- user_favorites_movie_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the
-- `user_favorites_movie` table in the `moviesite` database.
-- It includes operations for managing user favorite movies and retrieving
-- favorite movie information.

DELIMITER //

-- Procedure: FavoriteMovie
-- Description: Adds a movie to a user's list of favorites.
-- Parameters:
--   userId (INT): The ID of the user who is favoriting the movie.
--   movieId (INT): The ID of the movie being favorited.
CREATE PROCEDURE FavoriteMovie(IN userId INT, IN movieId INT)
BEGIN
  INSERT INTO user_favorites_movie (user_id, movie_id) VALUES (userId, movieId);
END //
DELIMITER ;

DELIMITER //

-- Procedure: UnfavoriteMovie
-- Description: Removes a movie from a user's list of favorites.
-- Parameters:
--   userId (INT): The ID of the user who is unfavoriting the movie.
--   movieId (INT): The ID of the movie being unfavorited.
CREATE PROCEDURE UnfavoriteMovie(IN userId INT, IN movieId INT)
BEGIN
  DELETE FROM user_favorites_movie WHERE user_id = userId AND movie_id = movieId;
END //
DELIMITER ;

DELIMITER //

-- Function: GetFavoriteMovies
-- Description: Retrieves a list of a user's favorite movies.
-- Parameters:
--   userId (INT): The ID of the user whose favorite movies are to be retrieved.
-- Returns: A table containing the IDs of movies that are favorited by the specified user.
CREATE FUNCTION GetFavoriteMovies(userId INT)
RETURNS TABLE
RETURN SELECT movie_id FROM user_favorites_movie WHERE user_id = userId;
DELIMITER ;

DELIMITER //

-- Trigger: AfterInsertFavorite
-- Description: Performs actions after a movie is added to a user's favorites.
-- This can include updating favorite counts or other related data.
CREATE TRIGGER AfterInsertFavorite
AFTER INSERT ON user_favorites_movie
FOR EACH ROW
BEGIN
  -- Example: Update favorite count in a movie stats table
  -- UPDATE movie_stats SET favorite_count = favorite_count + 1 WHERE movie_id = NEW.movie_id;
  -- Add necessary actions based on your database schema and requirements.
END //
DELIMITER ;

DELIMITER //

-- Trigger: AfterDeleteFavorite
-- Description: Performs actions after a movie is removed from a user's favorites.
-- This can include updating favorite counts or other related data.
CREATE TRIGGER AfterDeleteFavorite
AFTER DELETE ON user_favorites_movie
FOR EACH ROW
BEGIN
  -- Example: Update favorite count in a movie stats table
  -- UPDATE movie_stats SET favorite_count = favorite_count - 1 WHERE movie_id = OLD.movie_id;
  -- Add necessary actions based on your database schema and requirements.
END //
DELIMITER ;
