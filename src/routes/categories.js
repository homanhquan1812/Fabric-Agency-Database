const express = require('express');
const router = express.Router();
const categoriesController = require('../app/controllers/CategoriesController');

router.get('/', categoriesController.index)
//router.post('/store', infoController.store)

module.exports = router