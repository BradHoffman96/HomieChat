const WebSocket = require('ws');
const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const passport = require('passport');
const morgan = require('morgan');

const config = require('./config/database.js');

const Message = require('./models/message.js');

mongoose.connect(config.database, { useCreateIndex: true, useNewUrlParser: true });

const port = 3000

const app = express();

app.use(morgan('dev'));
app.use(bodyParser.json({limit: '100mb'}));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(passport.initialize());

app.use('/', require('./routes'));

const server = new WebSocket.Server({ server: app.listen(port, () => {
  console.log("Server is now listening on port: " + port);
})});

server.on('connection', socket => {
  console.log("SOCKET CONNECTION");

  socket.on('message', message => {
    console.log(message);
    
    //TODO: Create new message, store it, send it to clients
    var json = JSON.parse(message);
    
    var messageObj = Message({
      timestamp: Date(),
      sender: json.sender,
      text: json.text
    });

    messageObj.save(function(err, newMessage) {
      if (err) throw err;

      if (newMessage) {
        server.clients.forEach(client => {
          client.send(JSON.stringify(newMessage));
        });
      } else {
        throw Error("Problem saving message");
      }
    });
  });
});
