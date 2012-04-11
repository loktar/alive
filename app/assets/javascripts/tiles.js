(function ($) {

  var TILE_SIZE = 50;

  window.Tiles = function (el) {
    this.$el = $(el);
  };

  Tiles.prototype = {
    updateTiles:function (tiles) {
      var self = this;

      var maxX = 0;
      var maxY = 0;


      self.$el.html('');
      for (var i = 0; i < tiles.length; i++) {
        var tile = tiles[i];

        maxX = Math.max(maxX, tile.x);
        maxY = Math.max(maxY, tile.y);

        var $tileEl = $('<div class="tile"></div>');
        $tileEl.css({
          height:TILE_SIZE,
          width:TILE_SIZE,
          top:tile.y * TILE_SIZE,
          left:tile.x * TILE_SIZE
        });

        var life_amount = Number(tile.life_amount);
        if (life_amount) {
          $tileEl.addClass('life');
          $tileEl.css({background:'rgba(0, 100, 0, ' + life_amount + ')'});
        }

        self.plotPoints(tile.plants, 'plant', $tileEl);
        self.plotPoints(tile.herbivores, 'herbivore', $tileEl);
        self.plotPoints(tile.carnivores, 'carnivore', $tileEl);

        self.$el.append($tileEl);
      }

      self.$el.css({
        height:TILE_SIZE * (maxY + 1),
        width:TILE_SIZE * (maxX + 1)
      });
    },

    plotPoints:function (points, className, $tileEl) {
      for (var i = 0; i < points.length; i++) {
        var point = points[i];
        var $pointEl = $('<div></div>').addClass(className).addClass('entity');
        $pointEl.css({
          top:point[0] * TILE_SIZE,
          left:point[1] * TILE_SIZE
        });

        $tileEl.append($pointEl);
      }
    }
  };
}(jQuery));