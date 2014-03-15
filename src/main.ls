
angular = require 'angular'

app = angular.module 'PodspecApp', []

app.controller 'PodspecController', ['$scope', '$http', ($scope, $http) !->
    $http.get 'data/podspecs.json' .success (d) !->
        $scope.podspec = d

    sigma.parsers.gexf 'data/podspecs.gexf', {
        container: 'graph-container'
        settings: {-enableHovering}
    }, (s) !->
        s.bind 'overNode', (e) !->
            $scope.package_name = e.data.node.label
            r = e.data.node['cam0:size']
            x = e.data.node['cam0:x'] + r
            y = e.data.node['cam0:y'] + r
            $scope.pos = "{left:#{x}, top:#{y}}"
            $scope.$apply!
        s.bind 'doubleClickStage clickStage render', (e) !->
            $scope.package_name = ''
            $scope.$apply!

]



