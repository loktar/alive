(function (app) {
  var showWorld = function showWorld () {
    jQuery('#world').append(app.world.el);
  };

  app.Router = Backbone.Router.extend({
    routes: {
      '2d': 'twoDimensions',
      '3d': 'threeDimensions'
    },

    twoDimensions: function () {
      app.world = new app.views.World({collection: app.tiles});
      showWorld();
    },

    threeDimensions: function () {
      app.world = new app.views.ThreeDeeWorld({collection: app.tiles});
      showWorld();
    }
  });
}(Alive));
