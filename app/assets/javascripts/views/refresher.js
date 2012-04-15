(function (app) {

  app.views.Refresher = Backbone.View.extend({
    events: {
      'click': 'toggleAutoRefresh'
    },

    initialize: function () {
      this.tiles = this.options.tiles;
      this.isStarted = false;
    },

    toggleAutoRefresh: function () {
      if (this.isStarted) {
        this.stopAutoRefresh();
      } else {
        this.startAutoRefresh();
      }
    },

    startAutoRefresh: function () {
      this.isStarted = true;
      this.$el.text('Stop');
      this.fetchNewTiles();
    },

    stopAutoRefresh: function () {
      this.isStarted = false;
      this.$el.text('Start');
    },

    fetchNewTiles: function () {
      if (this.isStarted) {
        $.ajax({
          url: '/worlds/current.json'
        }).done(_.bind(this.updateWorld, this));
      }
    },

    updateWorld: function (world) {
      this.model.addDataPoints({plants: world.plant_count, herbivores: world.herbivore_count, carnivores: world.carnivore_count});
      this.tiles.updateTiles(world.tiles);
      var self = this;
      setTimeout(function () {
        self.fetchNewTiles();
      }, 2000);
    }
  });

}(Alive));
