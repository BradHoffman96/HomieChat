const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const Schema = mongoose.Schema;

var UserSchema = new Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true},
  display_name: { type: String, required: true },
  groups: [String],
  created_at: Date
});

UserSchema.methods.comparePassword = function(password, callback) {
  bcrypt.compare(password, this.password, function (err, isMatch) {
    if (err) {
        return callback(err);
    }

    callback(null, isMatch);
  });
};

UserSchema.pre('save', function (next) {
  console.log('PASSWORD HASH');
  var user = this;

  if (this.isModified('password') || this.isNew) {
    console.log("GEN SALT");
    bcrypt.genSalt(10, function(err, salt) {
      if (err) {
        return next(err);
      }

      console.log("HASH");
      bcrypt.hash(user.password, salt, function (err, hash)  {
        if (err) {
          console.log(err);
          return next(err);
        }

        console.log("PASS IS HASHED");
        user.password = hash;
        next();
      });
    });
  } else {
    console.log("SOMETHING HAPPENED");
    return next();
  }
});

module.exports = mongoose.model("User", UserSchema);
