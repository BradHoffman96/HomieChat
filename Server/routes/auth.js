const mongoose = require('mongoose');
const passport = require('passport');
const config = require('../config/database.js');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');
const multer = require('multer');
const fs = require('fs');

const User = require('../models/user.js');
const Group = require('../models/group.js');

var storage = multer.diskStorage({
  destination: function(req, file, cb) {
    console.log(req.body);
    if (!fs.existsSync('./images')) {
      console.log("Creating images folder.");
      fs.mkdirSync('./images');
    }

    var dir = "./images/" + res.locals.user.id;
    if (!fs.existsSync(dir)) {
      console.log("Creating dir:" + dir);
      fs.mkdirSync(dir);
    }

    cb(null, dir);
  },
  filename: function(req, file, cb) {
    cb(null, "profile.jpg");
  }
});

var upload = multer({
  storage: storage,
  onError: function(err, next) {
    console.log(err);
    next(err);
  }
});

var createUser = function(req, res, next) {
  console.log(req.body);

  Group.findOne({}, function(err, group) {
    if (err) throw err;

    var newUser = new User({
      email: req.body.email,
      password: req.body.password,
      display_name: req.body.display_name,
      groups: [group._id],
      created_at: Date.now()
    });

    newUser.save(function(err, user) {
      if (err) {
        console.log(err);
        return res.status(500).json({success: true, err: err.msg});
      }
      console.log("User created");

      const token = jwt.encode(user, config.secret);

      res.locals.user = user;
      res.locals.token = token;
      //return res.status(200).json({success: true, msg: "CREATED_NEW_USER", token: token});
    });
  });
}

router.post("/register", createUser, upload.single('image'), (req, res) => {
  res.status(200).json({success: true, user: res.locals.user, token: res.locals.token});
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

router.get('/', passport.authenticate('jwt', {session: false}), function(req, res) {
  req.logout();
  res.json({success: true, msg: 'Sign out successful.'});
});

module.exports = router;
