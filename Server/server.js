const express = require('express');
const bodyParser = require('body-parser');
const passport = require('passport');
const morgan = require('morgan');
const app = express();

const authRoutes = require('./auth.js');

const port = 3000

app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(passport.initialize());

app.use('/', authRoutes);

app.listen(port, () => {
  console.log("Server is now listening on port: " + port);
})
