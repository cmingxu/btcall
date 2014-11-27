market.directive('btcChartDirective', ["$window", function ($window) {

  var window = angular.element($window);

  return {
    restrict: 'E',
    scope: {
      val: '='
    },
    link: function (scope, element, attrs) {
      // constants
      var margin = {top: 20, right: 20, bottom: 50, left: 50},
      width = $window.innerWidth - 320,
      height = 350,
      color = d3.interpolateRgb("#f77", "#77f");
      var x = d3.time.scale()
      .range([0, width]);

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
      var svg = d3.select(element[0])
      .append("svg")
      .attr("width", width)
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
        y.domain([d3.min(newVal, function (d) { return d.value; }) - 2, d3.max(newVal, function(d) { return d.value; }) + 2]);
        svg.append("path")
        .datum(newVal)
        .attr("class", "area")
        .attr("d", area);

        if(_.last(newVal)){
          last_value = _.last(newVal).value;
         svg.append("line").
           attr("x1", 0).
           attr("y1", y(last_value)).
           attr("x2", width).
           attr("y2", y(last_value)).
           style("stroke", "red").
           style("stroke-width", 2).transition().
           duration(500);
        }

        svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height+ ")")
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
