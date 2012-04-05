(function ($) {

  window.Tiles = function (el) {
    this.$el = $(el);
  };

  Tiles.prototype = {
    updateTiles:function (tiles) {
      var self = this;

      var maxX = 0;
      var maxY = 0;

      var tileSize = 20;

      self.$el.html('');
      for (var i = 0; i < tiles.length; i++) {
        var tile = tiles[i];

        maxX = Math.max(maxX, tile.x);
        maxY = Math.max(maxY, tile.y);

        var $tileEl = $('<div class="tile"></div>');
        $tileEl.css({
          height:tileSize,
          width:tileSize,
          top:tile.y * tileSize,
          left:tile.x * tileSize
        });

        var life_amount = Number(tile.life_amount);
        if (life_amount) {
          $tileEl.addClass('life');
          $tileEl.css({opacity:life_amount});
        }

        self.$el.append($tileEl);
      }

      self.$el.css({
        height:tileSize * (maxY + 1),
        width:tileSize * (maxX + 1)
      });
    }
  };
}(jQuery));