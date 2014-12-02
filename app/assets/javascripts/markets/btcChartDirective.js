market.directive('btcChartDirective', ["$window", function ($window) {

  var window = angular.element($window);

  return {
    restrict: 'E',
    scope: {
      val: '='
    },
    link: function (scope, element, attrs) {
      // constants
      var sidebar = $(".col-md-2");
      var margin = {top: 10, right: 10, bottom: 40, left: 50},
      width = $window.innerWidth - sidebar.width(),
      height = 350,
      color = d3.interpolateRgb("#f77", "#77f");
      var x = d3.time.scale()
      .rangeRound([0, width - margin.right]);

      var y = d3.scale.linear()
      .range([height, 0]);

      var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");

      var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");

      var area = d3.svg.area()
      .x(function(d) { return x(d.date); })
      .y0(height)
      .y1(function(d) { return y(d.value); });

      // set up initial svg object
      var parseDate = d3.time.format("%x");
      d3.select(element[0]).append("div")
      .style("position", "absolute")
      .style("top", "50px")
      .style("right", "20px")
      .style("zindex", "10")
      .html("<div id='current_info'>" +
            "<p><i class='fa fa-clock'></i><strong id='current_time'>3:13</strong></p>" +
            "<p><i class='fa fa-clock'></i><strong id='current_value'>2193.99</strong></p>" +
            "</div>");

      var svg = d3.select(element[0])
      .append("svg")
      .attr("width", width - margin.right)
      .attr("height", height + margin.bottom).append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



      scope.$watch('val', function (newVal, oldVal) {
        // clear the elements inside of the directive
        svg.selectAll('*').remove();

        // if 'val' is undefined, exit
        if (!newVal) {
          return;
        }

        newVal.forEach(function(d) {
          d.date = new Date(d.timestamp * 1000);
          d.value = parseFloat(d.value);
        });

        x.domain(d3.extent(newVal, function(d) { return d.date; }));
        y.domain([d3.min(newVal, function (d) { return d.value; }) - 1, d3.max(newVal, function(d) { return d.value; }) + 1]);

        //linearGradient
        svg.append("defs").append("linearGradient")
        .attr("id", "gradient")
        .attr("x1", 0).attr("y1", 0)
        .attr("x2", 0).attr("y2", "100%")
        .selectAll("stop")
        .data([
          {offset: "0%", color: "green"},
          {offset: "100%", color: "white"},
        ])
        .enter().append("stop")
        .attr("offset", function(d) { return d.offset; })
        .attr("stop-color", function(d) { return d.color; })
        .attr("stop-opacity", 0.4) ;

        //add aread
        svg.append("path")
        .datum(newVal)
        .attr("class", "area")
        .attr("d", area)
        .on("mouseout", function () {
          $("#current_info").hide();
        }).on("mousemove", function (e) {
          $("#current_info").show();
          $("#current_info #current_time").text(moment(x.invert(d3.mouse(this)[0])).format("hh:mm:SS"));
          $("#current_info #current_value").text(y.invert(d3.mouse(this)[1]).toFixed(2));
        });

        //line && mesh
        if(_.last(newVal)){
          last_value = _.last(newVal).value;
          svg.append("line").
            attr("x1", 0).
            attr("y1", y(last_value)).
            attr("x2", width).
            attr("y2", y(last_value)).
            attr("stroke-dasharray", "5,5")


          var time_spans = [],
          big_interval = 0,
          small_interval = 0;
          visible_time_window = _.last(newVal).timestamp - _.first(newVal).timestamp;
          //less than half an hour
          if(visible_time_window < 60 * 30){
            big_interval = 10 * 60;   // 10m
            small_interval = 1 * 60;  // 1m
          }
          //half hour and 2hs
          else if(visible_time_window >= 60 * 30 && visible_time_window <= 2 * 60 * 60){
            big_interval = 10 * 60;   // 10m
            small_interval = 5 * 60;  // 5m
          }
          //4 hours
          else if(visible_time_window >= 3 * 60 * 60 && visible_time_window <= 5 * 60 * 60){
            big_interval = 30 * 60;   // 30m
            small_interval = 10 * 60;  // 10m
          }
          //6 hours
          else if(visible_time_window >= 5 * 60 * 60 && visible_time_window <= 7 * 60 * 60){
            big_interval = 60 * 60;   // 30m
            small_interval = 30 * 60;  // 10m
          }
          //12 hours
          else if(visible_time_window >= 11 * 60 * 60){
            big_interval = 60 * 60;   // 30m
            small_interval = 30 * 60;  // 10m
          }

          //xaxis interval ticks
          xAxis.ticks(d3.time.second, small_interval);

          cls = "small_interval_class";
          var x_tick_values = x.ticks().map(function(t) { return t; });
          for (var i = x_tick_values.length - 1; i >= 0; i --) {
            var v = x_tick_values[i].getTime() ;
            if( v % 1000 % small_interval == 0 ){ cls = "small_interval_class"; }
            if ( v % 1000 % big_interval == 0 ) { cls = "big_interval_class"; }

            svg.append("line").
              attr("x1", x(v)).
              attr("y1", 0).
              attr("x2", x(v)).
              attr("y2", height).
              classed(cls, true);
          }

          var y_tick_values = y.ticks().map(function(t) { return t; });
          for (var i = y_tick_values.length - 1; i >= 0; i --) {
            var v = y_tick_values[i];
            svg.append("line").
              attr("x1", 0).
              attr("y1", y(v)).
              attr("x2", width - margin.right).
              attr("y2", y(v)).
              classed(cls, true);
          }
        } // end of if(_.last(newVal)


        svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

        svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("价格 (￥)");


      }, true);

      window.bind("resize", function () {
        console.log($window.innerWidth);
      });
    }
  }
}]);
