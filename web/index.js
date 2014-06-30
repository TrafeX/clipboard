var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var roomIds = {};
var nrUsers = 0;

function randomInt(low, high) {
    var nrLoops = 0;
    do {
        var number = Math.floor(Math.random() * (high - low) + low);
        if (++nrLoops > 5) {
            return new Error('All room numbers are taken');
        }
    } while (typeof(roomIds['room-' + number]) != 'undefined')

    return number;
}


app.get('/', function(req, res){
    res.sendfile('index.html');
});

io.on('connection', function(socket){

    socket.roomNr = randomInt(100000, 999999);
    if (socket.roomNr instanceof Error) {
        console.log('ERROR:', socket.roomNr);
        return;
    }

    socket.roomId = 'room-' + socket.roomNr;

    socket.emit('registered', socket.roomNr);

    roomIds[socket.roomId] = socket.roomId;
    ++nrUsers;

    console.log('User ' + nrUsers + ' registered in room: ' + socket.roomId);
    socket.on('disconnect', function(){
        delete roomIds[socket.roomId];
        --nrUsers;
        console.log('User disconnected from ' + socket.roomId);
    });
    socket.on('publish', function(msg){
        io.to(socket.roomId).emit('message', msg);
    });
    socket.on('join', function(room){
        if (typeof(roomIds['room-' + room]) == 'undefined') {
            socket.emit('global-error', 'Room doesn\'t exists. Fill in the room number of the "sending" device');
            return;
        }
        if (socket.subscribedRoom) {
            socket.leave(socket.subscribedRoom);
        }
        socket.subscribedRoom = 'room-' + room
        // @todo: Not working
        // io.to(socket.subscribedRoom).emit('subscribed-listener', socket.roomId);
        socket.join(socket.subscribedRoom);
        socket.emit('subscribed', room);
        console.log('User in room ' + socket.roomId + ' joins room ' + socket.subscribedRoom);
    });
});

http.listen(3000, function(){
    console.log('Listening on *:3000');
});
