(function (app) {

  app.views.Refresher = Backbone.View.extend({
    events: {
      'click': 'toggleAutoRefresh'
    },

    initialize: function () {
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
        }).done(_.bind(this.updateWorld, this))
          .fail(_.bind(this.stopAutoRefresh, this));
      }
    },

    updateWorld: function (world) {
      this.collection.reset(world.tiles);
      var self = this;
      setTimeout(function () {
        self.fetchNewTiles();
      }, 2000);
    }
  });

}(Alive));
