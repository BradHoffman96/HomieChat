const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');
const multer = require('multer');
const fs = require('fs');

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
  console.log(req.user);
  res.status(200).send(req.user);
});


//If user edits any details, it will take the user object currently stored on device
//then it will change what is necessary and upload another user entirely.
//So the whole object will get rewritten
router.post('/', passport.authenticate("jwt", {session: false}), function(req, res) {
 
  if (!req.body.birth_name || !req.body.display_name) {
    return res.status(400).json({success: false, msg: "Please send the correct fields."});
  }

  User.findById(req.user.id, function(err, user) {
    if (err) throw err;

    if (user) {
      user.birth_name = req.body.birth_name;
      user.display_name = req.body.display_name;

      user.save(function (err, newUser) {
        if (err) throw err;

        if (newUser) {
          res.status(200).json({success: true, msg: "User successfully updated."});
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

module.exports = router;
