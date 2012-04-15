(function (app) {
  app.views.World = Backbone.View.extend({
    tileSize: 50,

    events: {
      'click .entity': 'killEntity',
      'mouseover .entity': 'killEntity'
    },

    initialize: function () {
      this.collection.on('reset', this.render, this);
    },

    render: function () {
      var self = this, maxX = 0, maxY = 0;

      this.$el.empty();
      this.collection.each(function (tile) {
        var view = new app.views.Tile({model: tile, tileSize: self.tileSize});

        maxX = Math.max(maxX, tile.get('x'));
        maxY = Math.max(maxY, tile.get('y'));

        self.$el.append(view.render().$el);
      });

      this.$el.css({
        height: this.tileSize * (maxY + 1),
        width: this.tileSize * (maxX + 1)
      })
    },

    killEntity: function (e) {
      var entityId = this.$(e.target).data('entity');
      $.ajax({
        url: '/entities/' + entityId,
        type: 'DELETE'
      }).done(function () {
          app.allLife.remove(entityId);
        });
    }
  });
}(Alive));
