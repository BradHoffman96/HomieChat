const express = require('express');
const bodyParser = require('body-parser');
const passport = require('passport');
const morgan = require('morgan');
const app = express();

const port = 3000

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(passport.initialize());

app.use('/', (req, res) => {
  console.log("Hello, World!");
  res.send("Hello,world!");
});

app.listen(port, () => {
  console.log("Server is now listening on port: " + port);
})
