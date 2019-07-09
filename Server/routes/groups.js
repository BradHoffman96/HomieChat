const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');

const Group = require('../models/group.js');


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
      res.status(200).json({success: true, msg: "Group created."});
    } else {
      res.status(400).json({success: false, msg: "Error creating group."});
    }
  });

});

module.exports = router;
