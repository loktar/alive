(function (app){
  app.collections.TileLife = Backbone.Collection.extend({
    model: app.models.Entity,

    initialize: function () {
      this.on('died', this.removeDeadEntity, this);
    },

    removeDeadEntity: function(entity) {
      this.remove(entity);
    }
  });
}(Alive));
