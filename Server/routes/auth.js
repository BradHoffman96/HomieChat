const mongoose = require('mongoose');
const passport = require('passport');
const config = require('../config/database.js');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');

const User = require('../models/user.js');

router.post("/register", (req, res) => {
  console.log(req.body);

  var newUser = new User({
    email: req.body.email,
    password: req.body.password,
    birth_name: req.body.birth_name,
    display_name: req.body.display_name,
    created_at: Date.now()
  });

  console.log("PRE SAVE");

  newUser.save(function(err, user) {
    console.log("User created");
    if (err) {
      console.log(err);
      return res.status(500).json({success: true, err: err.msg});
    }

    const token = jwt.encode(user, config.secret);
    return res.status(200).json({success: true, msg: "CREATED_NEW_USER", token: token});
  });
});

router.post("/login", (req, res) => {
  console.log(req.body);

  User.findOne({email: req.body.email}, function(err, user) {
    if (err) throw err;

    if (!user) {
      return res.status(401).json({success: false, msg: 'Auth failed. User not found.'});
    } else {
      user.comparePassword(req.body.password, function(err, isMatch) {
        if (isMatch && !err) {
          var token = jwt.encode(user, config.secret);

          res.status(200).json({success: true, token: 'JWT ' + token});
        } else {
          res.status(401).json({success: false, msg: 'Auth failed. Wrong password.'});
        }
      });
    }
  });
});

router.get('/signout', passport.authenticate('jwt', {session: false}), function(req, res) {
  req.logout();
  res.json({success: true, msg: 'Sign out successful.'});
});

module.exports = router;
