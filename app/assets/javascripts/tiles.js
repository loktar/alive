(function ($) {
  $.fn.extend({
    tiles:function () {
      $(this).each(function () {
        var $self = $(this);

        $.ajax('/tiles.json', {
          success:function (tiles) {
            var maxX = 0;
            var maxY = 0;

            var tileSize = 50;

            for (var i = 0; i < tiles.length; i++) {
              var tile = tiles[i];

              maxX = Math.max(maxX, tile.x);
              maxY = Math.max(maxY, tile.y);

              var $tileEl = $('<div class="tile"></div>');
              $tileEl.css({
                height:tileSize,
                width:tileSize,
                top: tile.y * tileSize,
                left: tile.x * tileSize
              });
              $self.append($tileEl);
            }

            $self.css({
              height:tileSize * (maxY + 1),
              width:tileSize * (maxX + 1)
            });
          }
        });
      });
      return this;
    }
  });
}(jQuery));