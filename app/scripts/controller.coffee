# Require Views and Models
WelcomeView = require './views/welcome-view.coffee'
SearchView = require './views/search-view.coffee'
ContentLayout = require './views/content-layout.coffee'
MetaLayout = require './views/meta-layout.coffee'
ChartView = require './views/chart-view.coffee'
MetaView = require './views/meta-view.coffee'
BillModel = require './models/bill-model.coffee'


class MainController extends Marionette.Controller
  initialize: ( options ) ->

  getData: ( billId )->
    
    deferred = new $.Deferred()

    if not window.localStorage.getItem billId
      billModel = new BillModel id: billId
      billModel.fetch().then ( res ) ->
        window.localStorage.setItem billId, res
        deferred.resolve( billModel )
    else
      billModel = new BillModel JSON.parse window.localStorage.getItem billId
      deferred.resolve( billModel )

    deferred.promise()


  showBill: ( id ) ->
    @getData( id ).then ( billModel ) =>
      @showAll billModel

  home: ->
    currentCongress = 113
    firstBill = 'hr2397'
    firstBillId = currentCongress + '-' + firstBill
    @getData( firstBillId ).then ( billModel ) =>
      @showAll billModel
    
  showAll: ( billModel ) ->
      welcomeView = new WelcomeView model: billModel
      @options.regions.welcome.show welcomeView 

      searchView = new SearchView
      @options.regions.search.show searchView

      contentLayout = new ContentLayout
      @options.regions.content.show contentLayout

      chartView = new ChartView model: billModel
      contentLayout.chart.show chartView

      metaLayout = new MetaLayout
      contentLayout.meta.show metaLayout
      
      sponsor = new MetaView model: billModel
      sponsorTwo = new MetaView model: billModel
      sponsorThree = new MetaView model: billModel
      metaLayout[ 'meta1' ].show sponsor
      metaLayout[ 'meta2' ].show sponsorTwo
      metaLayout[ 'meta3' ].show sponsorThree

module.exports = MainController
