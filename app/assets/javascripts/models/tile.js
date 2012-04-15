(function (app) {
  app.models.Tile = Backbone.Model.extend({
    initialize: function () {
      this.set('plants', new app.collections.TileLife(this.get('plants')));
      this.set('herbivores', new app.collections.TileLife(this.get('herbivores')));
      this.set('carnivores', new app.collections.TileLife(this.get('carnivores')));

      this.collection = new app.collections.TileLife(this.allLife());
      app.allLife.addLife(this.collection);

      this.collection.on('died', this.notifyDied, this);
    },

    allLife: function () {
      return this.get('plants').models.concat(this.get('herbivores').models, this.get('carnivores').models);
    },

    notifyDied: function (entity) {
      this.trigger('death', entity);
    }
  });
}(Alive));
