(function ($) {

  var LIFE_GRAPH = 0;
  var HERB_GRAPH = 1;
  var CARN_GRAPH = 2;

  window.TilesRefresher = function (buttonEl, tiles, historicalData) {
    var self = this;

    self.tiles = tiles;
    self.$button = $(buttonEl);

    self.isStarted = false;
    self.$button.click(function () {
      self.toggleAutoRefresh();
    });

    self.historicalData = historicalData;
  };

  TilesRefresher.prototype = {
    toggleAutoRefresh:function () {
      if (this.isStarted) {
        this.stopAutoRefresh();
      } else {
        this.startAutoRefresh();
      }
    },

    startAutoRefresh:function () {
      this.isStarted = true;
      this.$button.text('Stop');
      this.fetchNewTiles();
    },

    stopAutoRefresh:function () {
      this.isStarted = false;
      this.$button.text('Start');
    },

    fetchNewTiles:function () {
      var self = this;
      if (this.isStarted) {
        $.ajax('/worlds/current.json', {
          success:function (world) {
            self.tiles.updateTiles(world.tiles);
            self.historicalData.addDataPoints({plants: world.plant_count, herbivores: world.herbivore_count, carnivores: world.carnivore_count});
            setTimeout(function () {
              self.fetchNewTiles();
            }, 2000);
          }
        });
      }
    }
  };

}(jQuery));
