(function (app) {
  app.collections.AllLife = Backbone.Collection.extend({
    model: app.models.Entity,

    initialize: function () {
      this.on('remove', this.markEntityDead, this);
    },

    addLife: function (tileLife) {
      this.add(tileLife.models);
    },

    markEntityDead: function (entity) {
      entity.die();
    }
  });
}(Alive));
