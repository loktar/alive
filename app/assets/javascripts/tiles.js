(function ($) {

  var TILE_SIZE = 50;

  window.Tiles = function (el) {
    this.$el = $(el);

    this.$el.on('click', '.entity', this.killEntity.bind(this));
    this.$el.on('mouseover', '.entity', this.killEntity.bind(this));
  };

  Tiles.prototype = {
    killEntity:function (e) {
      var self = this;

      var entityId = e.target.id.substring('entity-'.length);
      $.ajax({
        url: '/entities/' + entityId,
        type: 'DELETE',
        success: function() {
          var $entityEl = $(e.target);
          var $tileEl = $entityEl.parent('.tile');

          $entityEl.remove();
          self.updateLifeForTile($tileEl);
        }
      });
    },

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

        self.plotPoints(tile.plants, 'plant', $tileEl);
        self.plotPoints(tile.herbivores, 'herbivore', $tileEl);
        self.plotPoints(tile.carnivores, 'carnivore', $tileEl);

        self.updateLifeForTile($tileEl);

        self.$el.append($tileEl);
      }

      self.$el.css({
        height:TILE_SIZE * (maxY + 1),
        width:TILE_SIZE * (maxX + 1)
      });
    },

    updateLifeForTile: function($tileEl) {
      var life_amount = $tileEl.find('.plant').length * 0.05;
      if (life_amount) {
        $tileEl.addClass('life');
        $tileEl.css({background:'rgba(0, 100, 0, ' + life_amount + ')'});
      } else {
        $tileEl.removeClass('life');
      }
    },

    plotPoints:function (points, className, $tileEl) {
      for (var i = 0; i < points.length; i++) {
        var point = points[i];
        var $pointEl = $('<div></div>')
                .addClass(className).addClass('entity')
                .addClass(point.isOld ? 'old' : '')
                .attr({id: 'entity-' + point.id});

        $pointEl.css({
          top:point.y * TILE_SIZE,
          left:point.x * TILE_SIZE
        });

        $tileEl.append($pointEl);
      }
    }
  };
}(jQuery));
