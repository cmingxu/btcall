market.controller("btcchart", ["$scope", "btcSocket", function ($scope, btcSocket) {
  //connect connect_error connect_timeout reconnect reconnect_attempt reconnect_error
  //reconnect_failed

  btcSocket.on('connect', function () {
    console.log("just connected");

    var svg = dimple.newSvg("#btcchart", 590, 400);
    d3.tsv("/example_data.tsv", function (data) {
      data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
      var myChart = new dimple.chart(svg, data);
      myChart.setBounds(60, 30, 505, 305);
      var x = myChart.addCategoryAxis("x", "Month");
      x.addOrderRule("Date");
      myChart.addMeasureAxis("y", "Unit Sales");
      var s = myChart.addSeries(null, dimple.plot.area);
      myChart.draw();
    });
  });

  btcSocket.on('reconnect_attempt', function () {
    console.log("reconnect_attempt");
  });

  btcSocket.on('message', function (msg) {
    console.log(msg);
    console.log(JSON.parse(msg[0]));
  });
}]);
