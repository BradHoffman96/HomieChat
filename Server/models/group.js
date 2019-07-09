const mongoose = require('mongoose');
const Schema = mongoose.Schema;

var GroupSchema = new Schema({
  members: [String]
});

module.exports = mongoose.model('Groups', GroupSchema);
