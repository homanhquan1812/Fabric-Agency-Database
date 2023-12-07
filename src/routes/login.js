const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
 
const credentials = {
    email: 'admin@gmail.com',
    password: 'admin'
}

router.post('/', (req, res) => {
    const token = jwt.sign({
        email: req.body.email,
        password: req.body.password
    }, 'secret');

    req.session.token = token;

    if (req.body.email == credentials.email && req.body.password == credentials.password)
    {
        req.session.user = req.body.email
        // res.redirect(`/info?token=${token}`)
        res.redirect('home')
        // res.redirect(`/info?email=${req.body.email}&password=${req.body.password}`)  
    }
    else
    {
        res.redirect('/')
    }
})


/*
const loginController = require('../app/controllers/LoginController');

router.get('/', loginController.index)
*/
module.exports = router