// Generated by CoffeeScript 1.7.1
var App, MainController, MainRouter;

MainRouter = require('./router');

MainController = require('./controller');

App = new Backbone.Marionette.Application();

App.addRegions({
  info: '#info',
  search: '#search',
  chart: '#chart',
  meta: '#meta'
});

App.addInitializer((function(_this) {
  return function(options) {
    _this.router = new MainRouter({
      controller: new MainController({
        regions: {
          info: _this.info,
          search: _this.search,
          chart: _this.chart,
          meta: _this.meta
        }
      }),
      appRoutes: {
        'bill/:id': 'showBill'
      }
    });
    console.log(_this.router);
    return console.log(App);
  };
})(this));

App.on('initialize:after', function(options) {
  if (Backbone.history) {
    return Backbone.history.start({
      pushState: true
    });
  }
});

App.start();

module.exports = App;
