(function ($) {

  var LIFE_GRAPH = 0;
  var HERB_GRAPH = 1;

  window.TilesRefresher = function (buttonEl, tiles) {
    var self = this;

    self.tiles = tiles;
    self.$button = $(buttonEl);

    self.isStarted = false;
    self.$button.click(function () {
      self.toggleAutoRefresh();
    });

    self.dataPoints = [
      [],
      []
    ];
    self.plot = $.plot('#graph', self.dataPoints, {
      series:{ shadowSize:0 }, // drawing is faster without shadows
      yaxis:{ min:0 },
      xaxis:{ min:0 }
    });
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

    addData:function (world) {
      var self = this;

      self.dataPoints[LIFE_GRAPH].push([0, world.total_life]);
      self.dataPoints[HERB_GRAPH].push([0, world.herbivore_count]);
      for (var i = 0; i < self.dataPoints[LIFE_GRAPH].length; i++) {
        self.dataPoints[LIFE_GRAPH][i][0] = i;
        self.dataPoints[HERB_GRAPH][i][0] = i;
      }

      self.plot.setData(self.dataPoints);
      self.plot.setupGrid();
      self.plot.draw();
    },

    fetchNewTiles:function () {
      var self = this;
      if (this.isStarted) {
        $.ajax('/worlds/current.json', {
          success:function (world) {
            $('#herbivore_count').text(world.herbivore_count);
            $('#total_life').text(Number(world.total_life).toFixed(2));
            self.tiles.updateTiles(world.tiles);
            self.addData(world);
            setTimeout(function () {
              self.fetchNewTiles();
            });
          }
        });
      }
    }
  };

}(jQuery));