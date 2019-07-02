const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');

const User = require('../models/user.js');

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
  })

})

module.exports = router;
