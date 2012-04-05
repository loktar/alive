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
        $.ajax('/tiles.json', {
          success:function (newTiles) {
            self.tiles.updateTiles(newTiles);
            console.log("fetching new tiles");
            setTimeout(function() { self.fetchNewTiles(); });
          }
        });
      }
    }
  };

}(jQuery));