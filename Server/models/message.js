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
  likes: Number,
  likers: [String],
  media_url: String
});

module.exports = mongoose.model('Messages', MessageSchema);

