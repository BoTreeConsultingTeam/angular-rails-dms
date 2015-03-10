angular.module('angular-rails-dms.exampleApp').controller("WelcomeController", [
  '$scope', '$http' ,
  ($scope, $http) ->
    $http.get('/welcome/get_files').success(( data, status, header , config ) ->
      $scope.my_documents = data.my_uploads
      $scope.shared_documents = data.shared_uploads
    )
    $scope.getUrl = (x) ->
      previews = new FilePreviews
      previews.generate x.url, (err, result) ->
        document.getElementById('file-' + x.id).src = result.previewURL
])