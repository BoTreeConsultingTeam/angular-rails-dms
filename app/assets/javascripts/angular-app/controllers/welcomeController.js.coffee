angular.module('angular-rails-dms.exampleApp').controller("WelcomeController", [
  '$scope', '$http' ,
  ($scope, $http) ->
    $http.get('/welcome/get_files').success(( data, status, header , config ) ->
      $scope.my_documents = data.my_uploads
      $scope.shared_documents = data.shared_uploads
    )
])