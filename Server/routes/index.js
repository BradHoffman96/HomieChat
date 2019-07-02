var express = require('express');
var router = express.Router();

router.use('/auth', require('./auth.js'));
router.use('/profile', require('./profile.js'));

module.exports = router;
