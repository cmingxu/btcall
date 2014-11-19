var io = require("socket.io")(3001);
var log4js = require('log4js');
var redis = require("redis");
var _ = require('lodash-node/underscore');

var redis_list_key = "data_list_v796";
var default_return_len = 100;
var default_heartbeat_inteval = 5 * 1000;

//connect to redis / default access point used
var redis = redis.createClient();

//initialize logger
log4js.loadAppender('file');
log4js.addAppender(log4js.appenders.file('/tmp/btcall/log/node.log'), 'node');
var logger = log4js.getLogger('node');
logger.setLevel('DEBUG');


var ws_clients = [];

function format_data(raw_data_from_redis) {
  return raw_data_from_redis.map(function (d) {
    buy = parseFloat(JSON.parse(d)["buy"]);
    sell = parseFloat(JSON.parse(d)["sell"]);
    timestamp = JSON.parse(d)["timestamp"];
    return {"value": ((buy + sell)/2).toFixed(3), "timestamp": timestamp}
  });
}

io.on('connection', function (socket) {
  redis.lrange(redis_list_key, 0, default_return_len, function(err, data){
    logger.debug(format_data(data));
    socket.emit('message:batch', format_data(data));
  });

  task = setInterval(function () {
    redis.lrange(redis_list_key, 0, 0, function(err, data){
      logger.debug(format_data(data)[0]);
      socket.emit('message:single', format_data(data)[0]);
    });

  }, default_heartbeat_inteval);

  socket.on('disconnect', function () {
    clearInterval(task);
  });
});
