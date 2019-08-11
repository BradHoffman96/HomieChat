const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const ImageSchema = new Schema({
  sender: {
    type: String,
    required: true
  },
  data: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    required: true
  },
  messageId: {
    type: String,
    required: true
  }
  //TODO: Implement thumbnails
  //TODO: Implement Likes
});

module.exports = mongoose.model('Images', ImageSchema);

