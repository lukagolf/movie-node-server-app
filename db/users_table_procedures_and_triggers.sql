-- users_table_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the `users`
-- table in the `moviesite` database.
-- It includes operations for adding, updating, and deleting users, retrieving
-- user details, and ensuring data integrity.

DELIMITER //

-- Procedure: AddUser
-- Description: Inserts a new user into the `users` table.
-- Parameters:
--   username (VARCHAR(64)): The username of the new user.
--   pword (VARCHAR(64)): The password of the new user.
--   email (VARCHAR(100)): The email of the new user.
--   firstname (VARCHAR(64)): The first name of the new user.
--   lastname (VARCHAR(64)): The last name of the new user.
CREATE PROCEDURE AddUser(IN username VARCHAR(64), IN pword VARCHAR(64), IN email VARCHAR(100), IN firstname VARCHAR(64), IN lastname VARCHAR(64))
BEGIN
  INSERT INTO users (username, pword, email, firstname, lastname) VALUES (username, pword, email, firstname, lastname);
END //
DELIMITER ;

DELIMITER //

-- Procedure: UpdateUser
-- Description: Updates details of an existing user in the `users` table.
-- Parameters:
--   userId (INT): The ID of the user to update.
--   newUsername (VARCHAR(64)): The new username of the user.
--   newPword (VARCHAR(64)): The new password of the user.
--   newEmail (VARCHAR(100)): The new email of the user.
--   newFirstname (VARCHAR(64)): The new first name of the user.
--   newLastname (VARCHAR(64)): The new last name of the user.
CREATE PROCEDURE UpdateUser(IN userId INT, IN newUsername VARCHAR(64), IN newPword VARCHAR(64), IN newEmail VARCHAR(100), IN newFirstname VARCHAR(64), IN newLastname VARCHAR(64))
BEGIN
  UPDATE users SET username = newUsername, pword = newPword, email = newEmail, firstname = newFirstname, lastname = newLastname WHERE user_id = userId;
END //
DELIMITER ;

DELIMITER //

-- Procedure: DeleteUser
-- Description: Deletes a user from the `users` table.
-- Parameters:
--   userId (INT): The ID of the user to delete.
CREATE PROCEDURE DeleteUser(IN userId INT)
BEGIN
  DELETE FROM users WHERE user_id = userId;
END //
DELIMITER ;

DELIMITER //

-- Function: GetUser
-- Description: Retrieves user details based on `user_id`, `username`, or `email`.
-- Parameters:
--   searchTerm (VARCHAR(100)): The term used to search for the user.
-- Returns: A table containing users that match the search term.
CREATE FUNCTION GetUser(searchTerm VARCHAR(100))
RETURNS TABLE
RETURN SELECT * FROM users
       WHERE user_id LIKE CONCAT('%', searchTerm, '%')
          OR username LIKE CONCAT('%', searchTerm, '%')
          OR email LIKE CONCAT('%', searchTerm, '%');
DELIMITER ;

DELIMITER //

-- Trigger: BeforeInsertUser
-- Description: Validates new user data before insertion. Ensures that the username and email are unique.
CREATE TRIGGER BeforeInsertUser
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  DECLARE existingUsernameCount INT;
  DECLARE existingEmailCount INT;
  SELECT COUNT(*) INTO existingUsernameCount FROM users WHERE username = NEW.username;
  SELECT COUNT(*) INTO existingEmailCount FROM users WHERE email = NEW.email;
  IF existingUsernameCount > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate username detected';
  END IF;
  IF existingEmailCount > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate email detected';
  END IF;
END //
DELIMITER ;

DELIMITER //

-- Trigger: BeforeDeleteUser
-- Description: Handles cleanup before deleting a user. This can include
-- removing the user's related data in other tables.
-- Note: Specific cleanup actions will depend on the relational dependencies
-- and business logic.
CREATE TRIGGER BeforeDeleteUser
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
  -- Example cleanup action: DELETE FROM some_table WHERE user_id = OLD.user_id;
  -- Add necessary cleanup queries based on your database schema and requirements.
END //
DELIMITER ;
