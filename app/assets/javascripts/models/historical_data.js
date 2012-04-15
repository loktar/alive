(function (app){
  app.models.HistoricalData = Backbone.Model.extend({
    initialize: function () {
      this.set('plants', []);
      this.set('herbivores', []);
      this.set('carnivores', []);
    },

    dataPoints: function () {
      return [
        this.get('plants'),
        this.get('herbivores'),
        this.get('carnivores')
      ];
    },

    plantCount: function () {
      return this.countFor('plants');
    },

    herbivoreCount: function () {
      return this.countFor('herbivores');
    },

    carnivoreCount: function () {
      return this.countFor('carnivores');
    },

    addDataPoints: function (points) {
      var dataPointNumber = this.get('plants').length;
      this.get('plants').push([dataPointNumber, points.plants]);
      this.get('herbivores').push([dataPointNumber, points.herbivores]);
      this.get('carnivores').push([dataPointNumber, points.carnivores]);

      this.trigger('change');
    },

    countFor: function (lifeType) {
      var list = this.get(lifeType);
      return list.length == 0 ? 0 : list[list.length - 1][1];
    }
  });
}(Alive));
