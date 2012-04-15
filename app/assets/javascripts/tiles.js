(function ($) {

  var TILE_SIZE = 50;

  window.Tiles = function (el) {
    this.$el = $(el);

    this.$el.on('click', '.entity', this.killEntity.bind(this));
    this.$el.on('mouseover', '.entity', this.killEntity.bind(this));
  };

  Tiles.prototype = {
    killEntity: function (e) {
      var self = this;

      var entityId = $(e.target).data('entity');
      $.ajax({
        url: '/entities/' + entityId,
        type: 'DELETE'
      }).done(function () {
          Alive.allLife.remove(entityId);
        });
    },

    updateTiles: function (tiles) {
      var self = this;

      var maxX = 0;
      var maxY = 0;

      self.$el.html('');
      Alive.allLife = new Alive.collections.AllLife();
      _(tiles).each(function (tile) {
        var model = new Alive.models.Tile(tile);
        var view = new Alive.views.Tile({model: model, tileSize: TILE_SIZE});

        maxX = Math.max(maxX, model.get('x'));
        maxY = Math.max(maxY, model.get('y'));

        self.$el.append(view.render().$el);
      });

      self.$el.css({
        height: TILE_SIZE * (maxY + 1),
        width: TILE_SIZE * (maxX + 1)
      });
    }
  };
}(jQuery));
