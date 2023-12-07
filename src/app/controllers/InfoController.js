const oracledb = require('oracledb');

class InfoController {
    index(req, res, next) {
        res.render('info')
    }

    create(req, res, next)
    {
        res.render('info/create', {
            styles: ['../css/infosStyle.css']
        })
    }

    //store(req, res, next) {

    //}    
}

module.exports = new InfoController