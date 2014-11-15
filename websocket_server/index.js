var io = require("socket.io")(3001);
var log4js = require('log4js');
var redis = require("redis");

var redis_list_key = "data_list_v796";
var default_return_len = 0;
var default_heartbeat_inteval = 5 * 1000;

//connect to redis / default access point used
var redis = redis.createClient();

//initialize logger
log4js.loadAppender('file');
log4js.addAppender(log4js.appenders.file('/tmp/btcall/log/node.log'), 'node');
var logger = log4js.getLogger('node');
logger.setLevel('DEBUG');


var ws_clients = [];


io.on('connection', function (socket) {
  task = setInterval(function () {
    redis.lrange(redis_list_key, 0, default_return_len, function(err, data){
      logger.debug(data);
      socket.emit('message', data);
    });

  }, default_heartbeat_inteval);

  socket.on('disconnect', function () {
    clearInterval(task);
  });
});
