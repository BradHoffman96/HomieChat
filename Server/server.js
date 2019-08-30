const WebSocket = require('ws');
const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const passport = require('passport');
const morgan = require('morgan');

const config = require('./config/database.js');

const Message = require('./models/message.js');
const Image = require('./models/image.js');

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
    console.log("new message");
    var json = JSON.parse(message);

    var messageObj = Message({
      timestamp: Date(),
      sender: json.sender
    });

    if (json['image']) {
      messageObj.image = json['image'];
    } else if (json['text']) {
      messageObj.text = json['text'];
    } else {
      return res.status(400).json({success: false, msg: "Please send an 'image' or 'text'"});
    }

    messageObj.save(function(err, newMessage) {
      if (err) throw err;

      if (newMessage) {

        if (newMessage.image) {
          var image = Image({
            timestamp: Date(),
            sender: newMessage.sender,
            messageId: newMessage._id,
            data: newMessage.image
          });

          image.save(function(err, newImage) {
            if (err) throw err;

            if (!newImage) {
              throw Error("Problem saving image");
            }
          });
        }

        server.clients.forEach(client => {
          client.send(JSON.stringify(newMessage));
        });
      } else {
        throw Error("Problem saving message");
      }
    });
  });
});

app.use(function(err, req, res, next) {
  if (err) throw err;

  if (res.locals.updatedDetails) {
    var updateMessage = {
      msg: "DETAILS_UPDATED"
    }

    server.clients.forEach(client => {
      client.send(JSON.stringify(updatedMessage));
    });
  }
});
