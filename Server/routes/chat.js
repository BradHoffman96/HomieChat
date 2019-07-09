const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');


router.post("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  res.status(200).json({success: true, msg: "POST msg"});
});

module.exports = router;
