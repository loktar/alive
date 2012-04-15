(function (app) {
  app.models.Entity = Backbone.Model.extend({
    die: function () {
      this.trigger('died', this);
    }
  });
}(Alive));
