-- users_table_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the `users`
-- table in the `moviesite` database.
-- It includes operations for adding, updating, and deleting users, retrieving
-- user details, and ensuring data integrity.
USE moviesite;
DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
-- Procedure: add_user
-- Description: Inserts a new user into the `users` table.
-- Parameters:
--   username (VARCHAR(64)): The username of the new user.
--   pword (VARCHAR(64)): The password of the new user.
--   email (VARCHAR(100)): The email of the new user.
--   role1 (ENUM ('Admin', 'Viewer', 'Critic')): user's role on site (mandatory).
--   role2 (ENUM ('Admin', 'Viewer', 'Critic')): secondary site role (optional).
--   firstname (VARCHAR(64)): The first name of the new user.
--   lastname (VARCHAR(64)): The last name of the new user.
CREATE PROCEDURE add_user(IN username VARCHAR(64), 
						  IN pword VARCHAR(64), 
                          IN email VARCHAR(100), 
                          IN role1 ENUM ('Admin', 'Viewer', 'Critic'), 
                          IN role2 ENUM ('Admin', 'Viewer', 'Critic'), 
                          IN firstname VARCHAR(64), 
                          IN lastname VARCHAR(64))
BEGIN
  INSERT INTO users (username, pword, email, role1, role2, firstname, lastname) 
			VALUES (username, pword, email, role1, role2, firstname, lastname);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_user;
DELIMITER //
-- Procedure: update_user
-- Description: Updates details of an existing user in the `users` table.
-- Parameters:
--   old_username (VARCHAR(64)): The username of the user to update.
--   new_username (VARCHAR(64)): The new username of the user.
--   new_pword (VARCHAR(64)): The new password of the user.
--   new_email (VARCHAR(100)): The new email of the user.
--   new_role1 (ENUM ('Admin', 'Viewer', 'Critic')): user's role on site (mandatory)
--   new_role2 (ENUM ('Admin', 'Viewer', 'Critic')): secondary site role (optional)
--   new_firstname (VARCHAR(64)): The new first name of the user.
--   new_lastname (VARCHAR(64)): The new last name of the user.
CREATE PROCEDURE update_user(IN old_username VARCHAR(64),
							 IN new_username VARCHAR(64), 
                             IN new_pword VARCHAR(64), 
                             IN new_email VARCHAR(100), 
                             IN new_role1  ENUM ('Admin', 'Viewer', 'Critic'), 
                             IN new_role2  ENUM ('Admin', 'Viewer', 'Critic'), 
                             IN new_firstname VARCHAR(64), 
                             IN new_lastname VARCHAR(64))
BEGIN
  UPDATE users SET username = new_username, 
				   pword = new_pword, 
                   email = new_email, 
                   role1 = new_role1, 
                   role2 = new_role2, 
                   firstname = new_firstname, 
                   lastname = new_lastname 
                   WHERE username = old_username;
END //
DELIMITER ;

-- Procedure: delete_user
-- Description: Deletes a user from the `users` table.
-- Parameters:
--   user_id_del (INT): The ID of the user to delete.
DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //
CREATE PROCEDURE delete_user(IN user_id_del INT)
BEGIN
  DELETE FROM user_likes_review WHERE user_id = user_id_del;
  DELETE FROM user_dislikes_review WHERE user_id = user_id_del;
  DELETE FROM user_favorites_movie WHERE user_id = user_id_del;
  DELETE FROM user_follows_user WHERE follower_id = user_id_del OR
									  followed_id = user_id_del;
  DELETE FROM users WHERE user_id = userId;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_user;
DELIMITER //
-- Function: get_user
-- Description: Retrieves user details based on `first_name`, 'last_name', `username`, or `email`.
-- Parameters:
--   searchTerm (VARCHAR(100)): The term used to search for the user.
-- Returns: A table containing users that match the search term.
CREATE PROCEDURE get_user(search_term VARCHAR(100))
BEGIN
SELECT * FROM users
   WHERE first_name LIKE CONCAT('%', search_term, '%')
	  OR last_name LIKE CONCAT('%', search_term, '%')
	  OR CONCAT(first_name, ' ', last_name) LIKE CONCAT('%', search_term, '%')
	  OR username LIKE CONCAT('%', search_term, '%')
	  OR email LIKE CONCAT('%', search_term, '%');
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_user_by_id;
DELIMITER //
-- Function: get_user_by_id
-- Description: Retrieves user details corresponding to supplied id
-- Parameters:
--   user_id_p (INT): ID of the user to be returned
-- Returns: A table containing users that match the search term.
CREATE PROCEDURE get_user_by_id(user_id_p INT)
BEGIN
SELECT * FROM users
   WHERE user_id = user_id_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_by_username;
DELIMITER //
CREATE PROCEDURE get_by_username(username_p VARCHAR(64))
BEGIN
SELECT * FROM users
	WHERE username = username_p;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_all_users;
DELIMITER $$
CREATE PROCEDURE get_all_users()
BEGIN
SELECT * FROM users;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_by_login;
DELIMITER $$
CREATE PROCEDURE get_by_login(username_p VARCHAR(64), pword_p VARCHAR(64))
BEGIN
SELECT * FROM users
	WHERE username_p = username AND
		  pword_p = pword;
END $$
DELIMITER ;

SELECT * FROM reviews;