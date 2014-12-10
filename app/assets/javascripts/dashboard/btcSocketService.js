angular.module('dashboard').factory('btcSocket', ['socketFactory', function (socketFactory) {
  return socketFactory({
    ioSocket: io.connect(config.websocket_url)
  });
}]);

