const express = require('express');
const router = express.Router();
const mainController = require('../controllers/mainController');

router.post('/', mainController.getHello);

module.exports = router;