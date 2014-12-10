dashboard.controller("btcchartController", ["$scope", "btcSocket", function ($scope, btcSocket) {
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
    $scope.timespan = 30 * 60;

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
        case 'message:timespan_change':
          $scope.data = [];
          $scope.data = data_sample(msg.data);
          break;
        case 'message:batch':
          $scope.data = data_sample(msg.data);
          break;
        case 'message:single':
          $scope.data.push(data_sample(msg.data)[0]);
          break;
        default:
      }
    });


    $scope.draw_btc_chart = function () {
      $scope.chart_dom = $("#btcchart");
    }

    $scope.change_timespan = function (timespan) {
      $scope.timespan = timespan;
      $(".timespan_switcher .btn").removeClass("active");
      $(".timespan_switcher .btn[data-timespan="+ timespan +"]").addClass("active");
      //axis interval change
      //refresh dataset
      btcSocket.emit("timespan_change", {"timespan": timespan})
    };

}]);
