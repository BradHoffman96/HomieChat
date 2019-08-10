const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');
const Message = require('../models/message.js');


router.post("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  res.status(200).json({success: true, msg: "POST msg"});
});

router.get("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  Message.find().sort({_id:-1}).limit(50).exec(function(err, messages) {
    if (err) throw err;

    if (messages) {
      console.log(messages);

      res.status(200).json({success: true, messages: messages});
    } else {
      res.status(400).json({success: false, msg: "Could not get messages"});
    }
  });
});

module.exports = router;
