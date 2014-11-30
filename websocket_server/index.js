var io = require("socket.io")(3001);
var log4js = require('log4js');
var redis = require("redis");
var _ = require('lodash-node/underscore');

var redis_list_key = ["v796", "okcoin", "bitstamp", "bitfinex", "huobi", "btce"];
var filtered_data_key = "filtered_data";
var default_return_len = 30 * 6;
var default_heartbeat_inteval = 3 * 1000;

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
  //initial returned value
  redis.lrange(filtered_data_key, 0, default_return_len, function (err, data) {
    msg = {"type": "message:batch", "data": data.reverse()};
    socket.send(JSON.stringify(msg));
  });

  //inteval returned data
  task = setInterval(function () {
    redis.lrange(filtered_data_key, 0, 0, function (err, data) {
      msg = {"type": "message:single", "data": data};
      socket.send(JSON.stringify(msg));
    });

  }, default_heartbeat_inteval);

  socket.on('timespan_change', function (message) {
    redis.lrange(filtered_data_key, 0, parseInt(message.timespan) / 10 , function (err, data) {
      msg = {"type": "message:timespan_change", "data": data.reverse()};
      socket.send(JSON.stringify(msg));
    });
  });

  socket.on('disconnect', function () {
    clearInterval(task);
  });
});
