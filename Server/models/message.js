const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MessageSchmea = new Schema({
  sender: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    required: true
  },
  content: {
    type: String,
    required: true 
  },
  group_id: {
    type: String,
    required: true
  },
  likes: Number,
  image_url: String
});

module.exports = mongoose.model('Messages', MessageSchema);

