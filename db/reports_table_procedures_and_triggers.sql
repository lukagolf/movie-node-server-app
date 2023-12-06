USE moviesite;

/* Procedure: submit_report
 * Does:      insert a new report filed by a user into the database
 * Params: 	  rep_category: the category of the report, sub_date: the date the report was submitted, aid: the id of the admin resolving the issue,
 *            rid: the id of the review being reported, resolve_status: whether or not the report was resolved by an admin, rep_text: what is written in the report
 */

DROP PROCEDURE IF EXISTS submit_report;
 DELIMITER $$
 CREATE PROCEDURE submit_report(IN rep_category 
			ENUM ('spam', 
				  'illegal', 
                  'harassment', 
                  'spoilers', 
                  'misinformation',
                  'other'), 
                  IN sub_date DATETIME, 
                  IN sub_id VARCHAR(64), 
                  IN aid VARCHAR(64),
                  IN rid INT, 
				  IN resolve_status BOOL, 
                  IN rep_text VARCHAR(500))
 BEGIN
  INSERT INTO reports (category, date_submitted, submitter_id, admin_id, rev_id, is_resolved, report_text) VALUES (rep_category, sub_date, sub_id, aid, rid, resolve_status, rep_text);
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


DROP PROCEDURE IF EXISTS get_category_reports;
-- Function: get_category_reports
-- Description: Retrieves a list of reports in a particular category.
-- Parameters:
--   report_category (ENUM): The category of the report.
-- Returns: A table containing the reports in a specific category.
DELIMITER $$
CREATE PROCEDURE get_category_reports(report_category ENUM('Unwanted commercial content or spam', 
				  'Illegal content', 
                  'Harassment or bullying', 
                  'Unmarked spoilers', 
                  'Misinformation',
                  'Other'))
BEGIN
SELECT * FROM reports WHERE category = report_category;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS view_reports_by_date;
DELIMITER $$
-- Function: view_reports_by_date
-- Description: Retrieves a list of reports submitted on a specific date.
-- Parameters:
--   sub_date (DATETIME): The date that the report was submitted.
-- Returns: A table containing the reports submitted on a specific date.
CREATE PROCEDURE view_reports_by_date(sub_date DATETIME)
BEGIN
SELECT * FROM reports WHERE  date_submitted = sub_date;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS get_submitter_reports;
DELIMITER $$
-- Function: get_submitter_reports
-- Description: Retrieves a list of reports submitted by a specific user.
-- Parameters:
--   sub_id (VARCHAR): The id of the user that submitted a report.
-- Returns: A table containing the reports submitted by a specific user.
CREATE PROCEDURE get_submitter_reports(sub_id VARCHAR(64))
BEGIN
SELECT * FROM reports WHERE submitter_id = sub_id;
END $$
DELIMITER ;




DROP PROCEDURE IF EXISTS get_admin_reports_with_movieId_and_review;
DELIMITER $$
-- Procedure: get_admin_reports_with_movieId_and_review
-- Description: Retrieves a list of reports assigned to a particular admin,
-- along with which movie it's associated with and the review in question. 
-- Parameters:
--   aid (VARCHAR): The id of the admin taking a certain report.
-- Returns: A table containing the reports being resolved by a specific admin.
CREATE PROCEDURE get_admin_reports_with_movieId_and_review(aid VARCHAR(64))
BEGIN
SELECT reports.*, movie_id, reviews.* FROM reports 
	JOIN reviews 
		USING (rev_id)
	JOIN movies
		USING (movie_id)
	WHERE admin_id = aid;
END $$
DELIMITER ;





-- Procedure: get_unresolved_reports
-- Description: Retrieves a list of reports that are unresolved.
-- Returns: A table containing the reports that are unresolved.
DROP PROCEDURE IF EXISTS get_unresolved_reports;
DELIMITER $$
CREATE PROCEDURE get_unresolved_reports()
BEGIN
SELECT * FROM reports WHERE is_resolved = FALSE;
END $$
DELIMITER ;

-- Function: getResolvedReports
-- Description: Retrieves a list of reports that are resolved.
-- Returns: A table containing the reports that are resolved.
DROP PROCEDURE IF EXISTS get_resolved_reports;
DELIMITER $$
CREATE PROCEDURE get_resolved_reports()
BEGIN
SELECT * FROM reports WHERE is_resolved = TRUE;
END $$
DELIMITER ;

-- Function: get_unresolved_for_admin
-- Description: Retrieves a list of reports that are resolved for a 
-- particular admin
-- Takes: aid (VARCHAR): Admin whose reports are desired
-- Returns: A table containing the reports that are resolved.
DROP PROCEDURE IF EXISTS get_unresolved_for_admin;
DELIMITER $$
CREATE PROCEDURE get_unresolved_for_admin(aid VARCHAR(64))
BEGIN
SELECT * FROM reports
WHERE is_resolved = FALSE
AND admin_id = aid;
END $$
DELIMITER ;

