"use strict";
var app = angular.module('alfred-extras', ['ui.router']);
app.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $stateProvider
    .state('root', {
        url: '',
        views: {
            'subheader': {
                templateUrl: 'website/template/list.subheader.html',
                controller: ['$scope', ListController]
            },
            'body': {
                templateUrl: 'website/template/list.body.html',
                controller: ['$scope', ListController]
            }
        }
    })
    .state('detail', {
        url: '/:choice',
        views: {
            'subheader': {
                templateUrl: 'website/template/detail.subheader.html',
                controller: ['$scope', '$stateParams', '$sce', DetailController]
            },
            'body': {
                templateUrl: 'website/template/detail.body.html',
                controller: ['$scope', '$stateParams', '$sce', DetailController]
            }
        }
    });
}]);

function ItemController($scope, $http) {
    $scope.items = {};
    
    $scope.name = function(response) {
        var start = response.indexOf('\n# ') + 3;
        var end = response.indexOf('\n', start);
        
        return response.substring(start, end);
    };
    
    $http.get('https://api.github.com/repos/TylerEich/Alfred-Extras/' + 'contents/Source?access_token=001a02138839885be592af28b8b0f615357c2cef&ref=gh-pages')
    .success(function(data) {
        for (var i = 0; i < data.length; i++) {            
            (function(i, data) {
                $http.get('Source/' + data[i].name + '/README.md')
                .success(function(response) {
                    $scope.items[data[i].name] = response;
                });
            })(i, data);
        }
    });
}

function ListController($scope) {
    $scope.summary = function(readme) {
        var start = readme.indexOf('\n#### ') + 6;
        var end = readme.indexOf('\n', start);
        
        return readme.substring(start, end);
    };
}

function DetailController($scope, $stateParams, $sce) {
    $scope.choice = $stateParams.choice;
    
    $scope.readme = function() {
        var readme = $scope.items[$scope.choice];
        
        if (!readme) return;
        
        // var start = readme.indexOf('\n# ') + 3;
//         var end = readme.indexOf('\n', start);
//         
//         readme = readme.substring(end);
        
        return $sce.trustAsHtml(marked(readme));
    };
}