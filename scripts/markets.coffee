mod = angular.module 'coinpagesApp'

mod.service 'markets', ->

  markets =

    kraken:

      name: "Kraken"

      currencies: ["EUR"]

      symbol: "krakenEUR"

      tradeFees: [
        {percent: 0.20/100, volumeLimit: 10 * 1000, period: 30},
      ]

      fees:
        default: 'sepa'

        withdraw:
          sepa: (amount) -> 0.90
          wireEUR: -> 5 #region specific
          wireUSD: -> 30 #USD

        deposit:
          sepa: (amount) -> 0
          wireEUR: (amount) -> 5
          wireUSD: (amount) -> 15 #USD

    bitstamp:

      name: "Bitstamp"

      currencies: ["USD"]

      symbol: "bitstampUSD"

      tradeFees: [
        {percent: 0.5/100, volumeLimit: 500, period: 30},
      ]

      fees:
        default: 'sepa'

        withdraw:
          sepa: (amount) -> 0.90 #euro conversion
          wire: (amount) ->
            fee = (amount * 0.09/100)
            fee = 15 if fee < 15
            return fee

        deposit:
          sepa: (amount) -> 0
          wire: (amount) -> 0

    # btce:

    #   name: "BTC-e"

    #   currencies: ["USD", "EUR"]

    #   symbol: "btceUSD"

    #   tradeFees: [
    #     {percent: 0.2/100, volumeLimit: 100000, period: 30},
    #   ]

    #   fees:

    #     withdraw:
        
    #     deposit:


    bitfinex:

      name: "Bitfinex"

      currencies: ["USD"]

      symbol: "bitfinexUSD"

      tradeFees: [
        {percent: 0.1/100, volumeLimit: 500, period: 30}
      ]

      fees:

        default: 'wire'

        withdraw:
          wire: (amount) ->
            fee = (amount * 0.01/100)
            fee = 20 if fee < 20
            return fee

        deposit:
          wire: (amount) ->
            fee = (amount * 0.01/100)
            fee = 20 if fee < 20
            return fee


    virtex:

      name: "VirtEx"

      currencies: ["CAD"]

      symbol: "virtexCAD"

      tradeFees: [
        {percent: 1.5/100, volumeLimit: 400, period: 120},
      ]

      fees:

        default: 'direct'

        withdraw:
          direct: (amount) -> 6

        deposit:
          direct: (amount) -> 5
          bill: (amount) -> 20

    vos:

      name: "VoS"

      currencies: ["CAD"]

      symbol: "vosCAD"

      tradeFees: [
        {percent: 1.0/100}, #USD based ranges
      ]

      fees:

        default: 'direct'

        withdraw:
          direct: (amount) -> 0 #cheque
          wire: (amount) ->
            fee = (amount * 0.2/100)
            fee = 25 if fee < 25
            fee = 135 if fee > 135
            return fee

        deposit:
          wire: (amount) -> 15
          direct: (amount) -> 5


  updateLiveData = (data) ->
    for key, market of markets  
      if data.symbol is market.symbol
        console.log "updated #{data.symbol}"
        market.calculatedData =
          tradeFees: {}
        market.liveData = data
    return

  calculateNet = (rateKey, amount) ->
    multiplier = if rateKey is 'bid' then -1 else 1
    if (rate = this.liveData?[rateKey])?
      (rate * amount) + (this.calculateTradeFees(rateKey, amount) * multiplier)
    else
      0

  calculateFees = (balance, feeType, activeFee) ->
    activeFee = this.fees?.default
    if activeFee? and (feeFn = this.fees?[feeType]?[activeFee])?
      feeFn balance
    else
      null

  calculateTradeFees = (rateKey, amount) ->
    if (rate = this.liveData?[rateKey])?
      (rate * amount * this.tradeFees[0].percent)
    else
      0

  for key, market of markets
    market.calculateTradeFees = calculateTradeFees
    market.calculateNet = calculateNet
    market.calculateFees = calculateFees

  return {
    updateLiveData: updateLiveData
    data: markets
  }