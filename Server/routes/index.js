var express = require('express');
var router = express.Router();

router.use('/auth', require('./auth.js'));

module.exports = router;
