const express = require('express');
const router = express.Router();
const infoController = require('../app/controllers/InfoController');

router.get('/', infoController.index)
router.get('/create', infoController.create)
//router.post('/store', infoController.store)

module.exports = router