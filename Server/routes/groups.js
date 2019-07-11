const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');
const multer = require('multer');
const fs = require('fs');

const Group = require('../models/group.js');
const User = require('../models/user.js');

var storage = multer.diskStorage({
  destination: function(req, file, cb) {
    console.log(req.body);
    if (!fs.existsSync('./images')) {
      console.log("Creating images folder.");
      fs.mkdirSync('./images');
    }

    var dir = "./images/" + req.params.id;
    if (!fs.existsSync(dir)) {
      console.log("Creating dir:" + dir);
      fs.mkdirSync(dir);
    }

    cb(null, dir);
  },
  filename: function(req, file, cb) {
    cb(null, "group.jpg");
  }
});

var upload = multer({
  storage: storage,
  onError: function(err, next) {
    console.log(err);
    next(err);
  }
});

router.post("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  console.log(req.user);

  const newGroup = new Group({
    owner: req.user.id,
    name: req.body.name,
    topic: req.body.topic,
    members: [req.user.id]
  });

  newGroup.save(function(err, group) {
    if (err) throw err;

    if (group) {
      User.findById(req.user.id, function(err, user) {
        if (err) throw err;

        if (user) {
          user.groups.push(group._id);
          user.save(function(err, newUser) {
            if (err) throw err;

            if (newUser) {
              res.status(200).json({success: true, msg: "Group created.", id: group._id});
            } else {
              res.status(400).json({success: false, msg: "Error saving group to user."});
            }
          });
        } else {
          res.status(400).json({success: false, msg: "Error finding user."});
        }
      });
    } else {
      res.status(400).json({success: false, msg: "Error creating group."});
    }
  });
});

router.post("/:id", passport.authenticate('jwt', {session: false}), upload.single('image'), function(req, res) {
  var groupId = req.params.id;

  Group.findById(groupId, function(err, group) {
    if (err) throw err;


    if (group) {

      if (!group.members.includes(req.user.id)) {
        return res.status(500).json({success: false, msg: "You are not authorized to edit this group."});
      }

      group.name = req.body.name;
      group.topic = req.body.topic;

      group.save(function(err, newGroup) {
        if (err) throw err;

        if (newGroup) {
          res.status(200).json({success: true, msg: "Group updated."});
        } else {
          res.status(400).json({success: false, msg: "An error occurred updating group."});
        }
      });
    } else {
      res.status(400).json({success: false, msg: "Could not find group."});
    }
  });
});

module.exports = router;
