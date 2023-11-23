USE moviesite;

/* Procedure: add_genre
 * Does:      inserts new genre with supplied name into genres table
 * Params: 	  genre_p: the name of the genre to be inserted
 */
DROP PROCEDURE IF EXISTS add_genre;
DELIMITER $$
CREATE PROCEDURE add_genre(genre_p VARCHAR(50))
BEGIN
INSERT INTO genres VALUES(genre_p);
END $$
DELIMITER ;

/* Trigger: normalize_genre_insert
 * Does:    converts all genres to uppercase before insertion into
 * 		    genres table to ensure detection of duplicate genre entries
 */
DROP TRIGGER IF EXISTS normalize_genre_insert;
CREATE TRIGGER normalize_genre_insert
BEFORE INSERT ON genres
FOR EACH ROW
SET NEW.genre_name = UPPER(NEW.genre_name);

/* Trigger: normalize_genre_update
 * Does:    converts updated genre name to uppercase to ensure detection of 
 *			duplicate genre entries
 */
DROP TRIGGER IF EXISTS normalize_genre_update;
CREATE TRIGGER normalize_genre_update
BEFORE UPDATE ON genres
FOR EACH ROW
SET NEW.genre_name = UPPER(NEW.genre_name);

/* Procedure: delete_genre
 * Does:      deletes genre with supplied name from genres table
 * Params: 	  genre_p: the name of the genre to be deleted
 */
DROP PROCEDURE IF EXISTS delete_genre;
DELIMITER $$
CREATE PROCEDURE delete_genre(genre_p VARCHAR(50))
BEGIN
DELETE FROM movie_has_genre WHERE genre_name = genre_p;
DELETE FROM genres WHERE genre_name = genre_p;
END $$
DELIMITER ;

/* Procedure: update_genre
 * Does:      updates the name of an existing genre in the genres table
 * Params: 	  old_genre_p: name of genre in DB before procedure call
 *			  new_genre_p: new name for target genre
 */
DROP PROCEDURE IF EXISTS update_genre;
DELIMITER $$
CREATE PROCEDURE update_genre(old_genre_p VARCHAR(50), new_genre_p VARCHAR(50))
BEGIN
UPDATE genres
SET genre_name = new_genre_p
WHERE genre_name = old_genre_p;
END $$
DELIMITER ;

/* Procedure: give_movie_genre
 * Does:      creates association between provided genre and movie in
 *			  movie_has_genre table. If genre does not exist, creates an
 *			  entry for it.
 * Params: 	  movie_id_p: id of movie with genre
 *			  genre_name_p: name of genre being associated with the movie
 * Signals:   SQLSTATE 45000 if given movie does not exist
 */
DROP PROCEDURE IF EXISTS give_movie_genre;
DELIMITER $$
CREATE PROCEDURE give_movie_genre(movie_id_p INT, genre_name_p VARCHAR(50))
BEGIN
	IF NOT EXISTS (SELECT movie_id FROM movies WHERE movie_id = movie_id_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Movie not found';
	ELSEIF NOT EXISTS (SELECT genre_name FROM genres WHERE genre_name = UPPER(genre_name_p)) THEN
		INSERT INTO genres VALUES (genre_name_p);
	END IF;
    INSERT INTO movie_has_genre VALUES(movie_id_p, UPPER(genre_name_p));
END $$
DELIMITER ;

/* Procedure: remove_movie_genre
 * Does:      Revokes specified genre associated with supplied movie.
 * Params: 	  movie_id_p: id of movie with genre
 *			  genre_name_p: name of genre being removed from the movie
 * Signals:   SQLSTATE 45000 if movie_id is invalid or genre was not 
 *			  associated with that movie. 
 */
DROP PROCEDURE IF EXISTS remove_movie_genre;
DELIMITER $$
CREATE PROCEDURE remove_movie_genre(movie_id_p INT, genre_name_p VARCHAR(50))
BEGIN
	IF NOT EXISTS (SELECT movie_id FROM movies WHERE movie_id = movie_id_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Movie not found';
	ELSEIF NOT EXISTS (SELECT * FROM movie_has_genre 
						WHERE movie_id = movie_id_p AND genre_name = genre_name_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Genre not linked to movie';
    END IF;
    DELETE FROM movie_has_genre WHERE movie_id = movie_id_p AND genre_name = genre_name_p;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_movie_genres
DELIMITER $$
/* Proecdure: get_movie_genres
 * Does: 	  returns list of genres for supplied movie
 * Takes:	  ID of movie whose genres will be retrieved
 * Signals:   SQLSTATE 45000 if supplied movie does not exist
 */
CREATE PROCEDURE get_movie_genres(mid INT)
BEGIN
IF NOT EXISTS (SELECT movie_id FROM movies WHERE movie_id = mid) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Movie not found';
END IF;
SELECT genre_name FROM movie_has_genre WHERE movie_id = mid;
END $$
DELIMITER ;