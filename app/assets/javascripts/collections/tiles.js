(function (app) {
  app.collections.Tiles = Backbone.Collection.extend({
    model: app.models.Tile,

    reset: function(models, options) {
      app.allLife.reset([], {silent: true});
      Backbone.Collection.prototype.reset.call(this, models, options);
    },

    plantCount: function () {
      return this.lifeCount('plants');
    },

    herbivoreCount: function () {
      return this.lifeCount('herbivores');
    },

    carnivoreCount: function () {
      return this.lifeCount('carnivores');
    },

    lifeCount: function (lifeType) {
      return this.reduce(function (count, tile) {
        return count + tile.get(lifeType).size();
      }, 0);
    }
  });
}(Alive));
