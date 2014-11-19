market.controller("btcchartController", ["$scope", "btcSocket", function ($scope, btcSocket) {
  socket_events = ["connect", "connect_error", "connect_timeout",
    "reconnect", "reconnect_attempt", "reconnect_error", "econnect_failed"];

    $scope.data = [];
    $scope.chart_dom = null;

    angular.forEach(socket_events, function (e) {
      btcSocket.on(e, function () {
        console.log(e);
      })
    });

    btcSocket.on('message:batch', function (msg) {
      $scope.data = msg;
    });

    btcSocket.on('message:single', function (msg) {
      $scope.data.unshift(msg);
      console.log($scope.data.length);
    });

    $scope.draw_btc_chart = function () {
      $scope.chart_dom = $("#btcchart");
    }

    $scope.redraw_btc_chart = function () {
      var svg = dimple.newSvg(chart_dom.get(0), chart_dom.width(), chart_dom.height());
      chart = new dimple.chart(svg, $scope.data);
      chart.addCategoryAxis("x", "timestamp");
      chart.addMeasureAxis("y", "value");
      chart.addSeries(null, dimple.plot.area);
      chart.draw();
    }

}]);
