const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MediaSchema = new Schema({
  message_id: {
    type: String,
    required: true
  },
  media_thumbnail: String,
  media_url: String
});

module.exports = mongoose.model('Media', MessageSchema);

