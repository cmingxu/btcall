market.controller("btcchartController", ["$scope", "btcSocket", function ($scope, btcSocket) {
  socket_events = ["connect", "connect_error", "connect_timeout",
    "reconnect", "reconnect_attempt", "reconnect_error", "econnect_failed"];

    $scope.vendors = {
      "v796": "V796",
      "okcoin": "OKCoin",
      "bitstamp": "Bitstamp",
      "bitfinex": "Bitfinex",
      "huobi": "火币",
      "btce": "Btce"
    };

    $scope.data = [];
    $scope.chart_dom = null;

    angular.forEach(socket_events, function (e) {
      btcSocket.on(e, function () {
        console.log(e);
      })
    });

    function data_sample(raw_data) {
      return raw_data.map(function (data) {
        timestamp = data.split("_")[0];
        values    = data.split("_")[1].split("|");
        values = _.filter(values, function (v) { return v != ""});
        sum = _.reduce(values, function (memo, v) { return memo += parseFloat(v); }, 0);
        return {"timestamp": timestamp, "value": (sum/values.length).toFixed(2)};
      });
    }

    btcSocket.on("message", function (msg) {
      msg = JSON.parse(msg);
      switch (msg.type) {
        case 'message:batch':
          $scope.data = data_sample(msg.data);
          break;
        case 'message:single':
          $scope.data.push(data_sample(msg.data)[0]);
          break;
        default:
      }

        console.log($scope.data);
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
