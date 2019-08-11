const passport = require('passport');
require('../config/passport')(passport);
const router = require('express').Router();
const jwt = require('jwt-simple');

const Image = require('../models/image.js');

router.post("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  res.status(200).json({success: true, msg: "POST template"});
});

router.get("/", passport.authenticate('jwt', {session:false}), function(req, res) {
  Image.find({}).sort({ _id: -1 }).limit(20).exec(function(err, images) {
    if (err) throw err;

    if (images) {
      res.status(200).json({success: true, images: images});
    } else {
      res.status(400).json({success: false, msg: "Could not get messages"});
    }
  });
});

router.get("/:imageId", passport.authenticate('jwt', {session:false}), function(req, res) {
  var page = req.params.imageId;

  //TODO: Might need to add some check to only return the max number of images possible.
  
  //Infinite scrolling can be done on the document _id since it has a timestamp.
  Image.find({ _id: { $lt: imageId } }).sort({ _id: -1 }).limit(20).exec(function(err, images) {
    if (err) throw err;

    if (images) {
      res.status(200).json({success: true, images: images});
    } else {
      res.status(400).json({success: false, msg: "Could not get messages"});
    }
  });
});

module.exports = router;
