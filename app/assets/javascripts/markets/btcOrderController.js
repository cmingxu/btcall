market.controller("btcOrderController", ["$scope", function ($scope) {

  $scope.direction = "down";
  $scope.investment = 100;
  $scope.roi_rate = 0.9;
  $scope.roi = 190;

  $scope.investmentChange = function () {
    $scope.roi = Math.floor($scope.investment * (1 + $scope.roi_rate));
  }
}]);
