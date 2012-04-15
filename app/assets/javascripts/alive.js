(function ($) {
  window.Alive = {
    models: {},
    collections: {},
    views: {},
    init: function () {
      var historicalData = new Alive.models.HistoricalData();
      var info = new Alive.views.Info({model: historicalData});
      info.render();

      var tiles = new Tiles('#tiles');

      new Alive.views.Refresher({model: historicalData, el: $('#auto_toggle'), tiles: tiles});
    }
  };
}(jQuery));
