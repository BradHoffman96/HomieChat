const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');

const Group = require('../models/group.js');
const User = require('../models/user.js');


router.post("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  console.log(req.user);

  const newGroup = new Group({
    owner: req.user.id,
    name: req.body.name,
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
              res.status(200).json({success: true, msg: "Group created."});
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

module.exports = router;
