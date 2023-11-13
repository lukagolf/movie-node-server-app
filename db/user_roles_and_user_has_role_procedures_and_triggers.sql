-- user_roles_and_user_has_role_procedures_and_triggers.sql
-- This file contains procedures, functions, and triggers for the `user_roles` and `user_has_role` tables in the `moviesite` database.
-- It includes operations for assigning and revoking user roles, and retrieving user role information.

DELIMITER //

-- Procedure: AssignRole
-- Description: Assigns a role to a user.
-- Parameters:
--   userId (INT): The ID of the user to whom the role is being assigned.
--   roleName (VARCHAR(64)): The name of the role being assigned.
CREATE PROCEDURE AssignRole(IN userId INT, IN roleName VARCHAR(64))
BEGIN
  INSERT INTO user_has_role (user_id, role_name) VALUES (userId, roleName);
END //
DELIMITER ;

DELIMITER //

-- Procedure: RevokeRole
-- Description: Revokes a role from a user.
-- Parameters:
--   userId (INT): The ID of the user from whom the role is being revoked.
--   roleName (VARCHAR(64)): The name of the role being revoked.
CREATE PROCEDURE RevokeRole(IN userId INT, IN roleName VARCHAR(64))
BEGIN
  DELETE FROM user_has_role WHERE user_id = userId AND role_name = roleName;
END //
DELIMITER ;

DELIMITER //

-- Function: GetUserRoles
-- Description: Retrieves the roles assigned to a specific user.
-- Parameters:
--   userId (INT): The ID of the user whose roles are to be retrieved.
-- Returns: A table containing the names of roles assigned to the specified user.
CREATE FUNCTION GetUserRoles(userId INT)
RETURNS TABLE
RETURN SELECT role_name FROM user_has_role WHERE user_id = userId;
DELIMITER ;

DELIMITER //

-- Trigger: BeforeInsertUserRole
-- Description: Validates role assignment before inserting a new record into `user_has_role`.
-- Ensures that the role being assigned exists in the `user_roles` table.
CREATE TRIGGER BeforeInsertUserRole
BEFORE INSERT ON user_has_role
FOR EACH ROW
BEGIN
  DECLARE roleExists INT;
  SELECT COUNT(*) INTO roleExists FROM user_roles WHERE role_name = NEW.role_name;
  IF roleExists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Role does not exist';
  END IF;
END //
DELIMITER ;
