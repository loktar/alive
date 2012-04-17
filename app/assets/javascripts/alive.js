(function ($) {
  window.Alive = {
    models: {},
    collections: {},
    templates: {},
    views: {},
    init: function () {
      this.allLife = new Alive.collections.AllLife();
      this.tiles = new Alive.collections.Tiles();

      this.historicalData = new Alive.models.HistoricalData({tiles: this.tiles});
      this.info = new Alive.views.Info({model: this.historicalData});
      this.info.render();

      this.world = new Alive.views.World({el: $('#world'), collection: this.tiles});

      this.refresher = new Alive.views.Refresher({collection: this.tiles, el: $('#auto_toggle')});
    }
  };
}(jQuery));