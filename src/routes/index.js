const infoRouter = require('./info')
const loginRouter = require('./login')
const reportRouter = require('./report')
const logoutRouter = require('./logout')
const categoriesRouter = require('./categories')
const homeRouter = require('./home')

function route(app) {
    app.use('/info', infoRouter);
    app.use('/login', loginRouter)
    app.use('/logout', logoutRouter)
    app.use('/report', reportRouter)
    app.use('/categories', categoriesRouter)
    app.use('/home', homeRouter)
}

module.exports = route;
