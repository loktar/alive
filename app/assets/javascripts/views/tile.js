(function (app) {
  app.views.Tile = Backbone.View.extend({
    className: 'tile',
    template: app.templates.tile,

    initialize: function () {
      this.tileSize = this.options.tileSize;
      this.model.on('death', this.removeDeadEntity, this);
    },

    render: function () {
      this.$el.html(this.template({
        xMultiple: this.tileSize / this.model.get('width'),
        yMultiple: this.tileSize / this.model.get('height'),
        lives: this.model.collection.toJSON()
      }));

      this.$el.css({
        width: this.tileSize,
        height: this.tileSize
      });

      return this;
    },

    removeDeadEntity: function (entity) {
      this.$('#entity-' + entity.id).remove();
    }
  });
}(Alive));
