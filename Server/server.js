const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const passport = require('passport');
const morgan = require('morgan');

const config = require('./config/database.js');

mongoose.connect(config.database, { useCreateIndex: true, useNewUrlParser: true });

const port = 3000

const app = express();

app.use(morgan('dev'));
app.use(bodyParser.json({limit: '100mb'}));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(passport.initialize());

app.use('/', require('./routes'));

app.listen(port, () => {
  console.log("Server is now listening on port: " + port);
})
