market.controller("btcchart", ["$scope", "btcSocket", function ($scope, btcSocket) {
  btcSocket.on('message', function (msg) {
    console.log(msg);
    console.log(JSON.parse(msg[0]));
  });
}]);
