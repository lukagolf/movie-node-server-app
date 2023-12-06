import * as reportsDao from "./reports-dao.js";
// maybe I'll want to just resolve reports rather than update

const updateReport = async (req, res) => {
    const id = req.params.id
    const status = await reportsDao.updateReport(id, req.body);
    res.json(status);
};

const deleteReport = async (req, res) => {
    const id = req.params.id
    const status = await reportsDao.deleteReport(id);
    res.json(status);
};

const createReport = async (req, res) => {
    const newReport = await reportsDao.createReport(req.body);
    console.log("CREATING REPORT: " + JSON.stringify(newReport))
    res.json(newReport);
};

const getAllAdminReports = async (req, res) => {
    const adminid = req.params.adminid
    const reports = await reportsDao.getAdminReportsWithMovieAndReview(adminid);
    if (reports) {
        res.json(reports)
    } else {
        res.sendStatus(404)
    }
};reportsDao


const resolveReport = async (req, res) => {
    const rep_id = req.params.id
    const status = await reportsDao.resolveReport(rep_id)
    res.json(status)
}

const ReportsController = (app) => {
    app.post("/api/reports", createReport);
    app.get("/api/reports/:adminid", getAllAdminReports);
    app.put("/api/reports/:id", updateReport);
    app.put("/api/reports/resolve/:id", resolveReport);
    app.delete("/api/reports/:id", deleteReport);
};
export default ReportsController;