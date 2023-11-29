USE moviesite;

DROP FUNCTION IF EXISTS get_random_admin;
DELIMITER $$
/* Function: get_random_admin
 * Does: Gets a random admin from the database
 * Returns: The username of the chosen admin, or null if DB has no admins
 */
CREATE FUNCTION get_random_admin()
RETURNS VARCHAR(64) READS SQL DATA
BEGIN
DECLARE assigned_admin VARCHAR(64) DEFAULT NULL;
SELECT username INTO assigned_admin 
	FROM users
    WHERE role1 = 'Admin' OR
		  role2 = 'Admin'
    ORDER BY RAND()
    LIMIT 1;
RETURN assigned_admin;
END $$
DELIMITER ;

/* Procedure: assign_report
 * Does:      assigns a viewer-written report to a random admin for review 
 *			  can be called to reassign report as well
 *			  if there are no admins in DB, field will be left NULL
 * Params: 	  report_id: id of report being assigned
 */
DROP PROCEDURE IF EXISTS assign_report;
DELIMITER $$
CREATE PROCEDURE assign_report(report_id INT)
BEGIN
DECLARE assigned_admin VARCHAR(64) DEFAULT NULL;
SELECT get_random_admin() INTO assigned_admin;
IF (assigned_admin IS NOT NULL) THEN
-- Only assign admin if there are admins in DB
	UPDATE reports 
		SET admin_id = assigned_admin
		WHERE rep_id = report_id;
END IF;
END $$
DELIMITER ;

/* Procedure: validate_admin
 * Does:      ensures that user assigned to review the given report is
 *			  an admin. If no admin is assigned, automatically assigns one.
 * Params: 	  report_id: report whose admin_id field is being validated 
 * Signals:   SQLSTATE 45000 if given user is not null and isn't an admin
 */
DROP PROCEDURE IF EXISTS validate_admin;
DELIMITER $$
CREATE PROCEDURE validate_admin(admin_id_p VARCHAR(64))
BEGIN
IF admin_id_p IS NOT NULL THEN
	IF admin_id_p NOT IN
		(SELECT username FROM users
		 WHERE role1 = 'Admin' OR role2 = 'Admin') THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Assigned reviewer must be an admin';
		END IF;
	END IF;
END $$
DELIMITER ;

/* Trigger:   reviewer_is_admin_insert
 * Does:      Validates that user assigned to review a report is an admin
 *			  before tuple can be created for that report
 */
DROP TRIGGER IF EXISTS valid_admin_assigned;
DELIMITER $$
CREATE TRIGGER valid_admin_assigned
BEFORE INSERT ON reports
FOR EACH ROW
BEGIN
DECLARE assigned_admin VARCHAR(64) DEFAULT '';
IF (NEW.admin_id IS NOT NULL) THEN
	CALL validate_admin(NEW.admin_id);
ELSE 
	SET NEW.admin_id = (SELECT get_random_admin());
END IF;
END $$
DELIMITER ;

/* Trigger:   reviewer_is_admin_update
 * Does:      Validates that user assigned to review a report is still an
 *			  admin after report tuple has been updated
 */
DROP TRIGGER IF EXISTS reviewer_is_admin_update;
CREATE TRIGGER reviewer_is_admin_update
BEFORE UPDATE ON reports
FOR EACH ROW
CALL validate_admin(NEW.admin_id);

/* Procedure: reassign_admin_reports
 * Does:      Helper for reassign_reports trigger. Reassigns all unresolved
 *			  reports of the supplied admin to new admins. Note that this is
 *			  meant to be done after the supplied admin_id has been deleted, so
 *			  if it is called in another context, reports may get assigned back
 *			  to the same admin.
 * Takes:     admin_id_p: The id of the admin whose unresolved reports will be 
 *			  reassigned.
 */
DROP PROCEDURE IF EXISTS reassign_admin_reports;
DELIMITER $$
CREATE PROCEDURE reassign_admin_reports(admin_id_p VARCHAR(64))
BEGIN 
	DECLARE curr_report INT;
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE admin_reports_c CURSOR FOR 
		SELECT rep_id FROM reports 
        WHERE admin_id = admin_id_p AND is_resolved = FALSE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
	    SET done = TRUE;
	OPEN admin_reports_c;
    WHILE done = FALSE DO
		FETCH admin_reports_c INTO curr_report;
        CALL assign_report(curr_report);
	END WHILE;
    CLOSE admin_reports_c;
END $$
DELIMITER ;

/* Trigger:   reassign_reports
 * Does:      When an admin is deleted, reassigns all of their outstanding
 *			  reports to other admins.
 */
DROP TRIGGER IF EXISTS reassign_reports;
DELIMITER $$
CREATE TRIGGER reassign_reports
AFTER DELETE ON users
FOR EACH ROW
BEGIN
	IF (OLD.role1 = 'Admin' OR OLD.role2 = 'Admin') THEN
		CALL reassign_admin_reports(OLD.username);
	END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS assign_unassigned_reports;
DELIMITER $$
/* 
 * Procedure: assign unassigned reports
 * Does: Helper for daily_admin_assignment event. Makes sure that
 * 		 any unassigned reports are assigned to an admin at the end
 *       of every day.
 */
CREATE PROCEDURE assign_unassigned_reports()
	BEGIN
		DECLARE curr_report INT;
		DECLARE done BOOLEAN DEFAULT FALSE;
		DECLARE admin_reports_c CURSOR FOR 
			SELECT rep_id FROM reports 
			WHERE admin_id IS NULL AND is_resolved = FALSE;
		DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET done = TRUE;
		OPEN admin_reports_c;
		WHILE done = FALSE DO
			FETCH admin_reports_c INTO curr_report;
			CALL assign_report(curr_report);
		END WHILE;
    CLOSE admin_reports_c;
END $$
DELIMITER ;

DROP EVENT IF EXISTS daily_admin_assignment;
DELIMITER $$
/* Event: daily admin assignment 
 * Does: Every day, makes sure there are no reports that aren't assigned to an 
 *       admin. This ensures that if an admin account gets deleted, all reports
 *       are eventually assigned to someone else. 
 */
CREATE EVENT daily_admin_assignment
ON SCHEDULE EVERY 1 DAY
DO BEGIN
CALL assign_unassigned_reports();
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS resolve_all_review_reports;
DELIMITER $$
CREATE PROCEDURE resolve_all_review_reports(rev_id_p INT)
BEGIN
DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE curr_report INT;
DECLARE review_reports_c CURSOR FOR 
	SELECT rep_id FROM reports 
	WHERE rev_id = rev_id_p;
DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET done = TRUE;
OPEN review_reports_c;
WHILE done = FALSE DO
	FETCH review_reports_c INTO curr_report;
	CALL resolve_report(curr_report);
END WHILE;
CLOSE review_reports_c;
END $$
DELIMITER ; 

DROP TRIGGER IF EXISTS resolve_reports_deleted_review;
/* Trigger: resolve_reports_deleted_review
 * Does: 	resolves all outstanding reports for a review if said
 *			review is deleted
 */
CREATE TRIGGER resolve_reports_deleted_review
BEFORE DELETE ON reviews
FOR EACH ROW
CALL resolve_all_review_reports(OLD.rev_id);
