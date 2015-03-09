angular.module('angular-rails-dms.exampleApp').controller("ExampleController", [
  '$scope',
  ($scope)->
    console.log 'ExampleCtrl running'

    $scope.exampleValue = "Hello angular and rails"

])