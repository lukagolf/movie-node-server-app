USE moviesite;

/* Procedure: add_review
 * Does:      inserts new review and returns inserted review on success
 * Params: 	  rev_title: the name of the review to be inserted, mid: the movie_id the review is about,
 *            r_text: the review that the user writes, date_r: the date that the review was written, rate: the rating that the user gives the movie,
 *            cid: the id of the critic that writes the review
 */

 DROP PROCEDURE IF EXISTS add_review;
 DELIMITER $$
 CREATE PROCEDURE add_review(IN rev_title VARCHAR(50), IN mid INT, IN r_text VARCHAR(10000), IN date_r DATETIME, 
 IN rate INT, IN cid VARCHAR(64))
 BEGIN
  INSERT INTO reviews (title, movie_id, review_text, date_reviewed, rating, critic_id) VALUES (rev_title, mid, r_text, date_r, rate, cid);
  SELECT * FROM reviews WHERE movie_id = mid AND critic_id = cid;
 END $$
 DELIMITER ;

/* Procedure: update_review
 * Does:      updates existing review 
 * Params: 	  review_id: the id of the review to be updated, rev_title: the name of the review to be inserted, mid: the movie_id the review is about,
 *            r_text: the review that the user writes, date_r: the date that the review was written, rate: the rating that the user gives the movie,
 *            cid: the id of the critic that writes the review
 */

DROP PROCEDURE IF EXISTS update_review;
DELIMITER $$
CREATE PROCEDURE update_review(IN review_id INT, IN rev_title VARCHAR(50), IN mid INT, IN r_text VARCHAR(10000), IN date_r DATETIME, 
 IN rate INT, IN cid VARCHAR(64))
BEGIN
  UPDATE reviews SET title = rev_title, movie_id = mid, review_text = r_text, date_reviewed = date_r, rating = rate, critic_id = cid
  WHERE rev_id = review_id;
END $$
DELIMITER ;


/* Procedure: delete_review
 * Does:        deletes existing review 
 * Params: 	    review_id: the id of the review to be deleted
 */
DROP PROCEDURE IF EXISTS delete_review;
DELIMITER $$
CREATE PROCEDURE delete_review(IN review_id INT)
BEGIN
  IF NOT EXISTS (SELECT rev_id FROM reviews WHERE rev_id = review_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Review not found';
  END IF;
  DELETE FROM user_likes_review WHERE rev_id = review_id;
  DELETE FROM user_dislikes_review WHERE rev_id = review_id;
  DELETE FROM reviews WHERE rev_id = review_id;
END $$
DELIMITER ;



/* Trigger: before_insert_review
 * Does:    
 */

DROP TRIGGER IF EXISTS before_insert_review;
DELIMITER $$
CREATE TRIGGER before_insert_review
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN

END $$
DELIMITER ;

/* Trigger: after_insert_review
 * Does:    
 */

 DROP TRIGGER IF EXISTS after_insert_review;
DELIMITER $$
CREATE TRIGGER after_insert_review
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN

END $$
DELIMITER ;



-- Function: get_critic_reviews_plus_movie
-- Description: Retrieves a list of reviews a particular critic has written
-- along with relevant movie information
-- Parameters:
--   cid (INT): The ID of the critic whose written reviews are to be retrieved.
-- Returns: A table containing the reviews written by the specific critic.
DROP PROCEDURE IF EXISTS get_critic_reviews_plus_movie;
DELIMITER $$
CREATE PROCEDURE get_critic_reviews_plus_movie(cid VARCHAR(64))
BEGIN
SELECT r.*, m.title AS movie_title, m.photo_url, m.movie_id, m.release_date, m.summary 
FROM reviews r JOIN movies m 
	USING (movie_id)
WHERE critic_id = cid;
END $$
DELIMITER ;

-- Function: get_movie_reviews
-- Description: Retrieves a list of reviews given a particular movie
-- Parameters:
--   mid (INT): The ID of the movie whose reviews are to be retrieved.
-- Returns: A table containing the reviews of the specific movie with the movie_id.
DROP PROCEDURE IF EXISTS get_movie_reviews;
DELIMITER $$
CREATE PROCEDURE get_movie_reviews(mid INT)
BEGIN
SELECT * FROM reviews WHERE movie_id = mid;
END $$
DELIMITER ;

-- Function: get_reviews_by_date
-- Description: Retrieves a list of reviews from a particular date
-- Parameters:
--   r_date (DATETIME): The date to retrieve reviews written on that date from.
-- Returns: A table containing all reviews written on a particular date.
DROP PROCEDURE IF EXISTS get_reviews_by_date;
DELIMITER $$
CREATE PROCEDURE get_reviews_by_date(r_date DATETIME)
BEGIN
SELECT * FROM reviews WHERE date_reviewed = r_date;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_review_by_id;
DELIMITER $$
CREATE PROCEDURE get_review_by_id(rev_id_p INT)
BEGIN
SELECT * FROM reviews WHERE rev_id = rev_id_p;
END $$
DELIMITER ;