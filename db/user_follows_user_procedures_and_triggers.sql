USE moviesite;
-- user_follows_user_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the
-- `user_follows_user` table in the `moviesite` database.
-- It includes operations for managing follower relationships and retrieving
-- follower information.

DROP PROCEDURE IF EXISTS follows_user;
DELIMITER //

-- Procedure: follows_user
-- Description: Adds a new follower relationship between two users.
-- Parameters:
--   follower_id_p (VARCHAR): The username of the user who is following.
--   followed_id_p (VARCHAR): The username of the user who is being followed.
CREATE PROCEDURE follows_user(IN follower_id_p VARCHAR(64), IN followed_id_p VARCHAR(64))
BEGIN
  INSERT INTO user_follows_user (follower_id, followed_id) VALUES (follower_id_p, followed_id_p);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS unfollow_user;
DELIMITER //

-- Procedure: unfollow_user
-- Description: Removes a follower relationship between two users.
-- Parameters:
--   follower_id_p (VARCHAR): The username of the user who is unfollowing.
--   followed_id_p (VARCHAR): The username of the user who is being unfollowed.
CREATE PROCEDURE unfollow_user(IN follower_id_p VARCHAR(64), IN followed_id_p VARCHAR(64))
BEGIN
  DELETE FROM user_follows_user WHERE follower_id = follower_id_p AND followed_id = followed_id_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_followers;
DELIMITER //
-- Function: get_followers
-- Description: Retrieves a list of followers for a specific user.
-- Parameters:
--   userId (INT): The ID of the user whose followers are to be retrieved.
-- Returns: A table containing the IDs of users who follow the specified user.
CREATE PROCEDURE get_followers(username VARCHAR(64))
BEGIN
SELECT follower_id FROM user_follows_user WHERE followed_id = username;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_following;
DELIMITER //
-- Function: get_following
-- Description: Retrieves a list of users that a specific user is following.
-- Parameters:
--   user_id (INT): The ID of the user whose followings are to be retrieved.
-- Returns: A table containing the IDs of users that the specified user is following.
CREATE PROCEDURE get_following(username VARCHAR(64))
BEGIN
SELECT followed_id FROM user_follows_user WHERE follower_id = username;
END //
DELIMITER ;
