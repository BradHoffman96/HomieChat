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
  text: String,
  image: String
  /* NOT IMPLEMENTED YET
  likes: Number,
  likers: [String],
  */
});

module.exports = mongoose.model('Messages', MessageSchema);

