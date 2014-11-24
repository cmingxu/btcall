var io = require("socket.io")(3001);
var log4js = require('log4js');
var redis = require("redis");
var _ = require('lodash-node/underscore');

var redis_list_key = ["v796", "okcoin", "bitstamp", "bitfinex", "huobi", "btce"];
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
  //initial returned value
  multi = redis.multi();
  for (var i = 0; i < redis_list_key.length; i ++) {
    multi.lrange("data_list_" + redis_list_key[i], 0, default_return_len);
  }
  multi.exec(function(err, data){
    formatted_data = {};
    for (var i = 0; i < redis_list_key.length; i ++) {
      formatted_data[redis_list_key[i]] = format_data(data[i]);
    }
    console.log(formatted_data);
    msg = {"type": "message:batch", "data": formatted_data};
    socket.send(JSON.stringify(msg));
  });

  //inteval returned data
  task = setInterval(function () {
    multi = redis.multi();
    for (var i = 0; i < redis_list_key.length; i ++) {
      multi.lrange("data_list_" + redis_list_key[i], 0, 0);
    }
    multi.exec(function(err, data){
      formatted_data = {};
      for (var i = 0; i < redis_list_key.length; i ++) {
        formatted_data[redis_list_key[i]] = format_data(data[i]);
      }
      console.log(formatted_data);
      msg = {"type": "message:single", "data": formatted_data};
      socket.send(JSON.stringify(msg));
    });

  }, default_heartbeat_inteval);

  socket.on('disconnect', function () {
    clearInterval(task);
  });
});
