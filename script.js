function ListController($scope) {
    // https://raw.github.com/TylerEich/Alfred-Extras/readme/Source/Colors/icon.png
    $scope.baseUrl = 'https://raw.github.com/TylerEich/Alfred-Extras/readme/Source/';
    $scope.items = [{
        name: 'Colors',
        path: 'Colors',
        packalUrl: 'colors'
    }, {
        name: 'Versions',
        path: 'Versions',
        packalUrl: 'versions'
    }, {
        name: 'Wolfram|Alpha',
        path: 'Wolfram-Alpha',
        packalUrl: 'wolframalpha'
    }];
}