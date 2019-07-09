var express = require('express');
var router = express.Router();

router.use('/auth', require('./auth.js'));
router.use('/profile', require('./profile.js'));
router.use('/chat', require('./chat.js'));

module.exports = router;
