const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MessageSchema = new Schema({
  sender: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    required: true
  },
  text: {
    type: String,
    required: true 
  },
  image_url: String
  /* NOT IMPLEMENTED YET
  likes: Number,
  likers: [String],
  */
});

module.exports = mongoose.model('Messages', MessageSchema);

