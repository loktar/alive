window.Alive = {
  models: {},
  collections: {},
  views: {},
  init: function () {
    var historicalData = new Alive.models.HistoricalData();
    var info = new Alive.views.Info({model: historicalData});
    info.render();

    var tiles = new Tiles('#tiles');
    new TilesRefresher('#auto_toggle', tiles, historicalData);
  }
};
