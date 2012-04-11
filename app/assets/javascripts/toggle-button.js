(function ($) {

  var LIFE_GRAPH = 0;
  var HERB_GRAPH = 1;
  var CARN_GRAPH = 2;

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
      [],
      []
    ];
    self.plot = $.plot('#graph', self.dataPoints, {
      colors: ['#90ee90', '#d1b38b', '#bb0000'],
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
      this.isStarted = true;
      this.$button.text('Stop');
      this.fetchNewTiles();
    },

    stopAutoRefresh:function () {
      this.isStarted = false;
      this.$button.text('Start');
    },

    addDataToGraph:function (world) {
      this.dataPoints[LIFE_GRAPH].push([0, world.total_life]);
      this.dataPoints[HERB_GRAPH].push([0, world.herbivore_count]);
      this.dataPoints[CARN_GRAPH].push([0, world.carnivore_count]);

      for (var i = 0; i < this.dataPoints[LIFE_GRAPH].length; i++) {
        this.dataPoints[LIFE_GRAPH][i][0] = i;
        this.dataPoints[HERB_GRAPH][i][0] = i;
        this.dataPoints[CARN_GRAPH][i][0] = i;
      }

      this.plot.setData(this.dataPoints);
      this.plot.setupGrid();
      this.plot.draw();
    },

    fetchNewTiles:function () {
      var self = this;
      if (this.isStarted) {
        $.ajax('/worlds/current.json', {
          success:function (world) {
            $('#herbivore_count').text(world.herbivore_count);
            $('#carnivore_count').text(world.carnivore_count);
            $('#total_life').text(Number(world.total_life).toFixed(2));

            self.tiles.updateTiles(world.tiles);
            self.addDataToGraph(world);
            setTimeout(function () {
              self.fetchNewTiles();
            });
          }
        });
      }
    }
  };

}(jQuery));