USE moviesite;

/* Procedure: submit_report
 * Does:      insert a new report filed by a user into the database
 * Params: 	  rep_category: the category of the report, sub_date: the date the report was submitted, aid: the id of the admin resolving the issue,
 *            rid: the id of the review being reported, resolve_status: whether or not the report was resolved by an admin, rep_text: what is written in the report
 */

DROP PROCEDURE IF EXISTS submit_report;
 DELIMITER $$
 CREATE PROCEDURE submit_report(IN rep_category ENUM('Unwanted commercial content or spam', 
				  'Illegal content', 
                  'Harassment or bullying', 
                  'Unmarked spoilers', 
                  'Misinformation',
                  'Other'), IN sub_date DATETIME, IN sub_id INT, IN aid INT, IN rid INT, 
 IN resolve_status BOOL, IN rep_text VARCHAR(500))
 BEGIN
  INSERT INTO reviews (category, date_submitted, submitter_id, admin_id, rev_id, is_resolved, report_text) VALUES (rep_category, sub_date, sub_id, aid, rid, resolve_status, rep_text);
 END $$
 DELIMITER ;


 /* Procedure: resolve_report
 * Does:       mark a report as resolved after it has been resolved by an admin
 * Params: 	   report_id: the id of the report to be marked as resolved
 */

DROP PROCEDURE IF EXISTS resolve_report;
DELIMITER $$
CREATE PROCEDURE resolve_report(IN report_id INT)
BEGIN
    UPDATE reports SET is_resolved = TRUE WHERE rep_id = report_id;
END $$
DELIMITER ; 

 /* Trigger: before_insert_report
 * Does:    
 */
DROP TRIGGER IF EXISTS beforeInsertReport;
DELIMITER $$
CREATE TRIGGER beforeInsertReport
BEFORE INSERT ON reports
FOR EACH ROW
BEGIN

END $$
DELIMITER ;


DELIMITER $$

-- Function: getCategoryReports
-- Description: Retrieves a list of reports in a particular category.
-- Parameters:
--   report_category (ENUM): The category of the report.
-- Returns: A table containing the reports in a specific category.
CREATE FUNCTION getCategoryReports(report_category ENUM('Unwanted commercial content or spam', 
				  'Illegal content', 
                  'Harassment or bullying', 
                  'Unmarked spoilers', 
                  'Misinformation',
                  'Other'))
RETURNS TABLE
RETURN SELECT * FROM reports WHERE category = report_category;
DELIMITER ;

DELIMITER $$


DELIMITER $$

-- Function: viewReportsByDate
-- Description: Retrieves a list of reports submitted on a specific date.
-- Parameters:
--   sub_date (DATETIME): The date that the report was submitted.
-- Returns: A table containing the reports submitted on a specific date.
CREATE FUNCTION viewReportsByDate(sub_date DATETIME)
RETURNS TABLE
RETURN SELECT * FROM reports WHERE  date_submitted = sub_date;
DELIMITER ;

DELIMITER $$


DELIMITER $$

-- Function: getSubmitterReports
-- Description: Retrieves a list of reports submitted by a specific user.
-- Parameters:
--   sub_id (INT): The id of the user that submitted a report.
-- Returns: A table containing the reports submitted by a specific user.
CREATE FUNCTION getSubmitterReports(sub_id INT)
RETURNS TABLE
RETURN SELECT * FROM reports WHERE submitter_id = sub_id;
DELIMITER ;

DELIMITER $$





DELIMITER $$

-- Function: getAdminReports
-- Description: Retrieves a list of reports resolved by a particular admin.
-- Parameters:
--   aid (INT): The id of the admin taking a certain report.
-- Returns: A table containing the reports being resolved by a specific admin.DROP FUNCTION IF EXISTS getAdminReports;
CREATE FUNCTION getAdminReports(aid INT)
RETURNS TABLE
RETURN SELECT * FROM reports WHERE admin_id = aid;
DELIMITER ;

DELIMITER $$




DELIMITER $$

-- Function: getUnresolvedReports
-- Description: Retrieves a list of reports that are unresolved.
-- Returns: A table containing the reports that are unresolved.
DROP FUNCTION IF EXISTS getUnresolvedReports;
CREATE FUNCTION getUnresolvedReports()
RETURNS TABLE
RETURN SELECT * FROM reports WHERE is_resolved = FALSE;
DELIMITER ;

DELIMITER $$



DELIMITER $$

-- Function: getResolvedReports
-- Description: Retrieves a list of reports that are resolved.
-- Returns: A table containing the reports that are resolved.
DROP FUNCTION IF EXISTS getResolvedReports;
CREATE FUNCTION getResolvedReports()
RETURNS TABLE
RETURN SELECT * FROM reports WHERE is_resolved = TRUE;
DELIMITER ;

DELIMITER $$