(function (app) {
  var directions = {
    up: 38,
    down: 40,
    left: 37,
    right: 39
  };

  app.views.World = Backbone.View.extend({
    tileSize: 250,
    className: 'world',
    arrowKeyDistance: 5,

    events: {
    },

    initialize: function () {
      this.collection.on('reset', this.render, this);
      $(document.body).on('keydown', this.moveScreenByArrowKey.bind(this));
    },

    render: function () {
      var self = this;

      if (this.$tiles) {
        this.$tiles.empty();
      } else {
        this.$tiles = $('<div class="tiles"></div>');
        this.$el.append(this.$tiles);
      }

      this.collection.each(function (tile) {
        var view = new app.views.Tile({model: tile, tileSize: self.tileSize});

        self.$tiles.append(view.render().$el);
      });

      return this;
    },

    moveScreenByArrowKey: function (e) {
      var position = this.$tiles.position();
      var top = position.top;
      var left = position.left;
      if (e.keyCode === directions.up) {
        top += this.arrowKeyDistance;
      } else if (e.keyCode === directions.down) {
        top -= this.arrowKeyDistance;
      } else if (e.keyCode === directions.left) {
        left += this.arrowKeyDistance;
      } else if (e.keyCode === directions.right) {
        left -= this.arrowKeyDistance;
      }

      var newTop = Math.min(0, Math.max(-1 * this.$tiles.height() + this.$el.height(), top));
      var newLeft = Math.min(0, Math.max(-1 * this.$tiles.width() + this.$el.width(), left));
      this.$tiles.css({top: newTop, left: newLeft});
    }
  });
}(Alive));
