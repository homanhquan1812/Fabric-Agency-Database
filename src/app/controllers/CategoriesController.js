const oracledb = require('oracledb');

class CategoriesController {
    index(req, res, next) {
        res.render('categories', {
            styles: ['../css/infosStyle.css']
        })
    }
}

module.exports = new CategoriesController