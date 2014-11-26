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
      data_sample_len = raw_data[_.first(_.keys($scope.vendors))].length
      data_samples = [];
      for (var i = 0; i < data_sample_len; i ++) {
        data_around_same_time = _.map(_.keys($scope.vendors), function (vendor) {
          return raw_data[vendor][i];
        });

        console.log(data_around_same_time);

        calculated_sample = {
          "value": _.reduce(data_around_same_time, function (memo, num) { return memo + parseFloat(num.value) }, 0) / _.keys($scope.vendors).length,
          "timestamp": _.reduce(data_around_same_time, function (memo, num) { return memo + num.timestamp }, 0) / _.keys($scope.vendors).length
        }
        data_samples.push(calculated_sample);
      }

      return data_samples;
    }

    btcSocket.on("message", function (msg) {
      msg = JSON.parse(msg);
      switch (msg.type) {
        case 'message:batch':
          $scope.data = data_sample(msg.data);
          break;
        case 'message:single':
          $scope.data.unshift(data_sample(msg.data)[0]);
          break;
        default:
      }
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
