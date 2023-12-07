const oracledb = require('oracledb');

class ReportController {
    index(req, res, next) {
        res.render('report', {
            styles: ['../css/infosStyle.css']
        })
    }
}

module.exports = new ReportController