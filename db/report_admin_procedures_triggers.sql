USE moviesite;

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
DECLARE assigned_admin INT;
SELECT user_id INTO assigned_admin 
	FROM users
    WHERE role1 = 'Admin' OR
		  role2 = 'Admin'
    ORDER BY RAND()
    LIMIT 1;
UPDATE reports 
	SET admin_id = assigned_admin
    WHERE rep_id = report_id;
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
CREATE PROCEDURE validate_admin(report_id INT)
BEGIN
DECLARE target_admin_id INT DEFAULT -1;
SELECT admin_id INTO target_admin_id FROM reports r
	WHERE report_id = r.rep_id;
IF target_admin IS NULL THEN
		CALL assign_report(report_id);
	ELSE
		IF target_admin_id NOT IN
		(SELECT user_id FROM users
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
DROP TRIGGER IF EXISTS reviewer_is_admin_insert;
CREATE TRIGGER reviewer_is_admin_insert
BEFORE INSERT ON reports
FOR EACH ROW
CALL validate_admin(NEW.rep_id);

/* Trigger:   reviewer_is_admin_update
 * Does:      Validates that user assigned to review a report is still an
 *			  admin after report tuple has been updated
 */
DROP TRIGGER IF EXISTS reviewer_is_admin_update;
CREATE TRIGGER reviewer_is_admin_update
BEFORE UPDATE ON reports
FOR EACH ROW
CALL validate_admin(NEW.rep_id);

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
CREATE PROCEDURE reassign_admin_reports(admin_id_p INT)
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
		CALL reassign_admin_reports(OLD.user_id);
	END IF;
END $$
DELIMITER ;