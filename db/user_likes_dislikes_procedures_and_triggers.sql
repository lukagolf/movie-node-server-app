USE moviesite;

/* Procedure: like_review
 * Does:      saves a review that was liked by a specific user.
 * Params: 	 us_id: the id of the user that liked the review, rid: the id of the review that was liked
 */
DROP PROCEDURE IF EXISTS like_review;
 DELIMITER $$
 CREATE PROCEDURE like_review(IN us_id INT, IN rid INT)
 BEGIN
  INSERT INTO user_likes_review (user_id, rev_id) VALUES (us_id, rid);
 END $$
 DELIMITER ;

/* Procedure: dislike_review
 * Does:      saves a review that was disliked by a specific user.
 * Params: 	 us_id: the id of the user that disliked the review, rid: the id of the review that was disliked
 */
DROP PROCEDURE IF EXISTS dislike_review;
 DELIMITER $$
 CREATE PROCEDURE dislike_review(IN us_id INT, IN rid INT)
 BEGIN
  INSERT INTO user_dislikes_review (user_id, rev_id) VALUES (us_id, rid);
 END $$
 DELIMITER ;

/* Procedure: unlike_review
 * Does:        deletes existing review after the user unlikes it
 * Params: 	    the id of the user that wants to unlike the review, rid: the id of the review to be unliked
 */
DROP PROCEDURE IF EXISTS unlike_review;
 DELIMITER $$
 CREATE PROCEDURE unlike_review(IN us_id INT, IN rid INT)
 BEGIN
  DELETE FROM user_likes_review WHERE user_id = us_id AND rev_id = rid;
 END $$
 DELIMITER ;

/* Procedure: undislike_review
 * Does:        deletes existing review after the user undislikes it
 * Params: 	    the id of the user that wants to undislike the review, rid: the id of the review to be undisliked
 */
DROP PROCEDURE IF EXISTS undislike_review;
 DELIMITER $$
 CREATE PROCEDURE undislike_review(IN us_id INT, IN rid INT)
 BEGIN
  DELETE FROM user_dislikes_review WHERE user_id = us_id AND rev_id = rid;
 END $$
 DELIMITER ;

DROP TRIGGER IF EXISTS AfterInsertLike;
DELIMITER $$
CREATE TRIGGER AfterInsertLike
AFTER INSERT ON user_likes_review
FOR EACH ROW
BEGIN

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS AfterDeleteLike;
DELIMITER $$
CREATE TRIGGER AfterDeleteLike
AFTER DELETE ON user_likes_review
FOR EACH ROW
BEGIN

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS AfterInsertDislike;
DELIMITER $$
CREATE TRIGGER AfterInsertDislike
AFTER INSERT ON user_dislikes_review
FOR EACH ROW
BEGIN

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS AfterDeleteDislike;
DELIMITER $$
CREATE TRIGGER AfterDeleteDislike
AFTER DELETE ON user_dislikes_review
FOR EACH ROW
BEGIN

END $$
DELIMITER ;


-- Function: getReviewLikes
-- Description: Retrieves a list of reviews that a specific user has liked
-- Parameters:
--   us_id (INT): The ID of the user whose liked reviews are to be retrieved.
-- Returns: A table containing the reviews that the specific user has liked.

DROP FUNCTION IF EXISTS getReviewLikes;
DELIMITER $$
CREATE FUNCTION getReviewLikes(us_id INT)
RETURNS TABLE
RETURN SELECT COUNT(*) FROM user_likes_review WHERE user_id = us_id;
END $$
DELIMITER ;


-- Function: getReviewDislikes
-- Description: Retrieves a list of reviews that a specific user has disliked
-- Parameters:
--   us_id (INT): The ID of the user whose disliked reviews are to be retrieved.
-- Returns: A table containing the reviews that the specific user has disliked.
DROP FUNCTION IF EXISTS getReviewDislikes;
DELIMITER $$
CREATE FUNCTION getReviewDislikes(us_id INT)
RETURNS TABLE
RETURN SELECT COUNT(*) FROM user_dislikes_review WHERE user_id = us_id;
END $$
DELIMITER ;


