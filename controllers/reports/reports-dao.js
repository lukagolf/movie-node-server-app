import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"

// might not work without id in destructured syntax
// just change args array, make sure it matches sql args
export const updateReport = (id, {
    category,
    date_submitted,
    submitter_id,
    admin_id,
    rev_id,
    is_resolved,
    report_text
  }
) => callProcedure('update_report', [
    id,
    category,
    date_submitted,
    submitter_id,
    admin_id,
    rev_id,
    is_resolved,
    report_text
  ]
 );

// export const deleteReport = (id) => callProcedure('delete_report', [id])

export const createReport = ({
    category,
    timestamp,
    username,
    rev_id,
    reportText
  }
) => callProcedure('submit_report', [
    category,
    timestamp,
    username, // submitter_id
    null, // admin_id
    rev_id,
    false, // is_resolved
    reportText
 ]
);

export const getAdminReportsWithMovieAndReview = (adminId) => 
    callProcedure('get_admin_reports_with_movieId_and_review', [adminId])

export const resolveReport = (repId) => 
    callProcedure('resolve_report', [repId])