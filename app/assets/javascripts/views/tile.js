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
        size: this.tileSize,
        lives: this.model.collection.toJSON()
      }));

      this.$el.css({
        width: this.tileSize,
        height: this.tileSize
      });

      this.updateLife();

      return this;
    },

    removeDeadEntity: function (entity) {
      this.$('#entity-' + entity.id).remove();
      this.updateLife();
    },

    updateLife: function () {
      var plantLife = this.model.get('plants').size() * 0.05;
      if (plantLife) {
        this.$el.addClass('life').css({
          background: 'rgba(0, 100, 0, ' + plantLife + ')'
        });
      } else {
        this.$el.removeClass('life');
      }
    }
  });
}(Alive));
