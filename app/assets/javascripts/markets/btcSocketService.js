angular.module('market').factory('btcSocket', ['socketFactory', function (socketFactory) {
  return socketFactory({
    ioSocket: io.connect(config.websocket_url)
  });
}]);

