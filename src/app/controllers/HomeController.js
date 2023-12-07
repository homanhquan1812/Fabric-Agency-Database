const oracledb = require('oracledb');

class HomeController {
    index(req, res, next) {
        res.render('home', {
            styles: ['../css/infosStyle.css']
        })
    }
}

module.exports = new HomeController