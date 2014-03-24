mod = angular.module 'coinpagesApp'

mod.service 'currencies', ->

  currencyPairs =

    'USD':

      'CAD': 1.123
      'CNY': 6.203
      'EUR': 0.726
      'USD': 1
      

    'EUR':

      'CAD': 1.548
      'CNY': 8.541
      'EUR': 1
      'USD': 1.379

    'CAD':

      'CAD': 1
      'CNY': 5.517
      'EUR': 0.644
      'USD': 0.889


mod.filter 'currencyConvert', ['currencies', (currencies) ->

  return (amount, currencyFrom, currencyTo) ->

    if amount and currencyFrom and currencyTo
      amount * currencies[currencyFrom][currencyTo]
    else
      "#{amount} and #{currencyFrom} and #{currencyTo}"

]