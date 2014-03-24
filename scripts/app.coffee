mod = angular.module 'coinpagesApp', []

mod.controller 'app', ['$scope', '$http', 'markets', 'currencies', ($scope, $http, markets, currencies) ->

  query = $http.get './data/markets.json'
  query.success (data) ->
    (markets.updateLiveData set) for set in data

  $http.get('https://api.vaultofsatoshi.com/public/ticker?order_currency=BTC&payment_currency=CAD').success (res) ->
    $http.get('https://api.vaultofsatoshi.com/public/orderbook?order_currency=BTC&payment_currency=CAD&count=3').success (book_res) ->
        market =
          symbol: "vosCAD"
          avg: Number(res.data.closing_price.value)
          bid: Number(book_res.data.bids[0].price.value)
          ask: Number(book_res.data.asks[0].price.value)
          volume: Number(res.data.units_traded.value)
        markets.updateLiveData market        

  $scope.currencies = currencies

  $scope.state =
    activeCurrency: 'USD'
    amountBaseline: 1000

  $scope.markets = markets.data

]