const express = require('express');
const router = express.Router();
const homeController = require('../app/controllers/HomeController');

router.get('/', homeController.index)
//router.post('/store', infoController.store)

module.exports = router