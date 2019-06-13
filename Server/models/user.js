const mongoose = require('mongoose');
const Schema = mongoose.Schema;

var userSchema = new Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true},
  display_name: { type: String, required: true },
  birth_name: { type: String, required: true },
  pic_path: { type: String, required: true },
  created_at: Date
});

var User = mongoose.mode('User', userSchema);

module.exports = User;
