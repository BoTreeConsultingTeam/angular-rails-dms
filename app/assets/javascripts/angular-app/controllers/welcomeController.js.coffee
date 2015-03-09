angular.module('angular-rails-dms.exampleApp').controller("WelcomeController", [
  '$scope', '$http' ,
  ($scope, $http) ->
    $http.get('/welcome/get_files').success(( data, status, header , config ) ->
      $scope.documents = data.my_uploads
      console.log data.my_uploads)
    $scope.getUrl = (x) ->
      previews = new FilePreviews
      previews.generate x.url, (err, result) ->
        console.log result.previewURL
        document.getElementById('file-' + x.id).src = result.previewURL
])