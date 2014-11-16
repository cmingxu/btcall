market.controller("btcchartController", ["$scope", "btcSocket", function ($scope, btcSocket) {
  //connect connect_error connect_timeout reconnect reconnect_attempt reconnect_error
  //reconnect_failed

  $scope.data = [];
  $scope.chart_dom = null;

  btcSocket.on('connect', function () {
    console.log("just connected");
  });

  btcSocket.on('reconnect_attempt', function () {
    console.log("reconnect_attempt");
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
