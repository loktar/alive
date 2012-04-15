(function (app) {
  app.views.Info = Backbone.View.extend({
    el: '#info',

    initialize: function () {
      this.plot = $.plot(this.$('#graph'), this.model.dataPoints(), {
        colors: ['#90ee90', '#d1b38b', '#bb0000'],
        series: { shadowSize: 0 }, // drawing is faster without shadows
        yaxis: { min: 0 },
        xaxis: { min: 0 }
      });

      this.model.on('change', this.render, this);
    },

    render: function () {
      this.$('#plant_count').text(this.model.plantCount());
      this.$('#herbivore_count').text(this.model.herbivoreCount());
      this.$('#carnivore_count').text(this.model.carnivoreCount());

      this.plot.setData(this.model.dataPoints());
      this.plot.setupGrid();
      this.plot.draw();
    }
  });

}(Alive));
