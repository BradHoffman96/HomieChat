const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const User = require('../models/user.js');

var storage = multer.diskStorage({
  destination: function(req, file, cb) {
    console.log(req.body);
    if (!fs.existsSync('./images')) {
      console.log("Creating images folder.");
      fs.mkdirSync('./images');
    }

    var dir = "./images/" + req.user.id;
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

router.get('/', passport.authenticate('jwt', { session: false }), function(req, res) {
  var user = req.user;
  user.password = undefined;
  console.log(user);
  res.status(200).json({success: true, user: user});
});

//If user edits any details, it will take the user object currently stored on device
//then it will change what is necessary and upload another user entirely.
//So the whole object will get rewritten
router.post('/', passport.authenticate("jwt", {session: false}), function(req, res) {
  User.findById(req.user.id, function(err, user) {
    if (err) throw err;

    if (user) {
      user.display_name = req.body.display_name;
      console.log(req.body.image);
      user.image = req.body.image;

      user.save(function (err, newUser) {
        if (err) throw err;

        if (newUser) {
          newUser.password = undefined;
          res.locals.updatedDetails = true;
          res.status(200).json({success: true, msg: "User successfully updated.", newUser: newUser});
        } else {
          res.status(400).json({success: false, msg: "Something went wrong."});
        }

      });
    }
  });
});

router.post('/image', passport.authenticate('jwt', {session: false}), upload.single('image'), function(req, res) {
  res.status(200).json({success: true, msg: "Image uploaded."});
});

router.get('/image', passport.authenticate('jwt', {session:false}), function(req, res) {
  var rootDir = path.join(__dirname, '../images', String(req.user.id), "profile.png");

  if (!fs.existsSync(rootDir)) {
    console.log("Does not exist: " + rootDir);
    res.status(400).json({success: false, msg:"Image cannot be found"});
  } else {
    res.sendFile(rootDir, {success: true, msg: "Found image for: " + req.user.email}, function(err) {
      if (err) {
        return res.status(500).json({success: false, msg: "Something went wrong while retrieiving image."});
      } else {
        console.log("Profile Image sent for: " + req.user.email);
      }
    });
  }
});

module.exports = router;
