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
          $scope.open_at_times_change();
        break;
        case 'message:single':
          latest_data = data_sample(msg.data)[0];
          if($scope.current_price && latest_data.value){
            $scope.trend = $scope.current_price - latest_data.value < 0 ? "up" : "down";
          }
          $scope.current_price = latest_data.value;
          $scope.data.push(latest_data);
          $scope.open_at_times_change();
        break;
        default:
      }
    });


    $scope.draw_btc_chart = function () {
      $scope.chart_dom = $("#btcchart");
    }

    $scope.open_at_times_change = function () {
      var  next_10_min_round = Math.round((new Date()).getTime() / 1000 / 600) * 600 * 1000 + 600 * 1000;
      console.log(next_10_min_round);
      $scope.open_times = [
        new Date(next_10_min_round),
        new Date(next_10_min_round + 10 * 60 * 1000),
        new Date(next_10_min_round + 20 * 60 * 1000),
        new Date(next_10_min_round + 30 * 60 * 1000),
        new Date(next_10_min_round + 40 * 60 * 1000),
        new Date(next_10_min_round + 50 * 60 * 1000),
        new Date(next_10_min_round + 60 * 60 * 1000)
      ];
    }

    $scope.change_timespan = function (timespan) {
      $scope.timespan = timespan;
      $(".timespan_switcher .btn").removeClass("active");
      $(".timespan_switcher .btn[data-timespan="+ timespan +"]").addClass("active");
      //axis interval change
      //refresh dataset
      btcSocket.emit("timespan_change", {"timespan": timespan})
    };

    $scope.direction = "down";
    $scope.investment = 100;
    $scope.roi_rate = 0.9;
    $scope.roi = 190;

    $scope.investmentChange = function () {
      $scope.roi = Math.floor($scope.investment * (1 + $scope.roi_rate));
    }

}]);