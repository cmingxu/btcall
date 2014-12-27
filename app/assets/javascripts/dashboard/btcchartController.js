dashboard.controller("btcchartController", ["$scope", "btcSocket", "$interval", "$http", function ($scope, btcSocket, $interval, $http) {
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
          $scope.selected_opening = $scope.open_times[0];
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
      $scope.open_times = [
        new Date(next_10_min_round),
        new Date(next_10_min_round + 10 * 60 * 1000),
        new Date(next_10_min_round + 20 * 60 * 1000),
        new Date(next_10_min_round + 30 * 60 * 1000),
        new Date(next_10_min_round + 40 * 60 * 1000),
        new Date(next_10_min_round + 50 * 60 * 1000)
      ];
    }

    $scope.format_opening = function (opening) {
      if(_.isUndefined(opening)){
        return "未设置";
      }
      var hour = opening.getHours();
      var min  = opening.getMinutes()

      return (hour.length == 1 ? "0" + hour : hour) + ":" + (min.length == 1 ? "0" + min : min);
    }

    $scope.change_timespan = function (timespan) {
      $scope.timespan = timespan;
      $(".timespan_switcher .btn").removeClass("active");
      $(".timespan_switcher .btn[data-timespan="+ timespan +"]").addClass("active");
      //axis interval change
      //refresh dataset
      btcSocket.emit("timespan_change", {"timespan": timespan})
    };

    $scope.opening_selector_open = function () {
      $(".opening_items").toggle();
    }

    $scope.opening_selected = function (index) {
      $scope.selected_opening = $scope.open_times[index];
      $(".opening_items").hide();
    }

    $interval(function () {
      $scope.remain_time =  moment($scope.selected_opening - (new Date())).format("mm:ss");
    }, 1000);

    $scope.direction = "down";
    $scope.investment = 0.1;
    $scope.roi_rate = 0.9;
    $scope.roi = 0.19;

    $scope.changeDirection = function(d) {
      $scope.direction = d;
    }

    $scope.investmentChange = function () {
      $scope.roi = Math.floor($scope.investment * (1 + $scope.roi_rate));
    }

    $scope.make_transaction = function () {
      $("#submit_bid_button").text("提交中...").addClass("disabled");
      var bid = {bid: {trend: $scope.direction,
        amount: Math.abs(parseFloat($scope.investment)),
        open_at: $scope.selected_opening}};

      $http.post("/dashboard/bids.json", bid, {"headers": {"Content-Type": "application/json"}}).success(function(data, status, headers, config){
        $('#myModal').modal('hide')
        $("#submit_bid_button").text("提交订单").removeClass("disabled");

      }).error(function(data, status, headers, config){
        $("#submit_bid_button").text("提交订单").removeClass("disabled");
      });
    }

}]);
