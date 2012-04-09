(function ($) {

  window.TilesRefresher = function (buttonEl, tiles) {
    var self = this;

    self.tiles = tiles;
    self.$button = $(buttonEl);

    self.isStarted = false;
    self.$button.click(function() { self.toggleAutoRefresh(); });
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
      var self = this;

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
            $('#herbivore_count').text(world.herbivore_count);
            $('#total_life').text(Number(world.total_life).toFixed(2));
            self.tiles.updateTiles(world.tiles);
            setTimeout(function() { self.fetchNewTiles(); });
          }
        });
      }
    }
  };

}(jQuery));