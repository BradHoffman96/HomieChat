const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TemplateSchema = new Schema({
  example: String
});

module.exports = mongoose.model('Templates', TemplateSchema);

