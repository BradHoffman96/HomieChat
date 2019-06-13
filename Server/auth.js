const passport =- require('passport');
const User = require('./models/user.js');
const router = require('express').Router();
const jwt = require('jwt-simple');

router.post("/register", (req, res) => {
  console.log(req.body);

  var newUser = new User({
    email: req.body.email,
    password: req.body.password,
    birth_name: req.body.birth_name,
    display_name: req.body.display_name,
    created_at: Date.now()
  });

  newUser.save(function(err, user) {
    console.log("User created");
    if (err) {
      console.log(err);
      return res.status(500).json({err: err.msg});
    }

    const token = jwt.encode(user, "key");
    return res.status(200).json({success: true, msg: "CREATED_NEW_USER", token: token});
  });
});

module.exports = router;
