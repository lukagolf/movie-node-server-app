-- user_follows_user_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the
-- `user_follows_user` table in the `moviesite` database.
-- It includes operations for managing follower relationships and retrieving
-- follower information.

DELIMITER //

-- Procedure: FollowUser
-- Description: Adds a new follower relationship between two users.
-- Parameters:
--   followerId (INT): The ID of the user who is following.
--   followedId (INT): The ID of the user who is being followed.
CREATE PROCEDURE FollowUser(IN followerId INT, IN followedId INT)
BEGIN
  INSERT INTO user_follows_user (follower_id, followed_id) VALUES (followerId, followedId);
END //
DELIMITER ;

DELIMITER //

-- Procedure: UnfollowUser
-- Description: Removes a follower relationship between two users.
-- Parameters:
--   followerId (INT): The ID of the user who is unfollowing.
--   followedId (INT): The ID of the user who is being unfollowed.
CREATE PROCEDURE UnfollowUser(IN followerId INT, IN followedId INT)
BEGIN
  DELETE FROM user_follows_user WHERE follower_id = followerId AND followed_id = followedId;
END //
DELIMITER ;

DELIMITER //

-- Function: GetFollowers
-- Description: Retrieves a list of followers for a specific user.
-- Parameters:
--   userId (INT): The ID of the user whose followers are to be retrieved.
-- Returns: A table containing the IDs of users who follow the specified user.
CREATE FUNCTION GetFollowers(userId INT)
RETURNS TABLE
RETURN SELECT follower_id FROM user_follows_user WHERE followed_id = userId;
DELIMITER ;

DELIMITER //

-- Function: GetFollowing
-- Description: Retrieves a list of users that a specific user is following.
-- Parameters:
--   userId (INT): The ID of the user whose followings are to be retrieved.
-- Returns: A table containing the IDs of users that the specified user is following.
CREATE FUNCTION GetFollowing(userId INT)
RETURNS TABLE
RETURN SELECT followed_id FROM user_follows_user WHERE follower_id = userId;
DELIMITER ;

DELIMITER //

-- Trigger: AfterInsertFollow
-- Description: Performs actions after a new follow relationship is created. 
-- This can include updating follower counts or other related data.
CREATE TRIGGER AfterInsertFollow
AFTER INSERT ON user_follows_user
FOR EACH ROW
BEGIN
  -- Example: Update follower count in a user stats table
  -- UPDATE user_stats SET follower_count = follower_count + 1 WHERE user_id = NEW.followed_id;
  -- Add necessary actions based on your database schema and requirements.
END //
DELIMITER ;

DELIMITER //

-- Trigger: AfterDeleteFollow
-- Description: Performs actions after a follow relationship is removed.
-- This can include updating follower counts or other related data.
CREATE TRIGGER AfterDeleteFollow
AFTER DELETE ON user_follows_user
FOR EACH ROW
BEGIN
  -- Example: Update follower count in a user stats table
  -- UPDATE user_stats SET follower_count = follower_count - 1 WHERE user_id = OLD.followed_id;
