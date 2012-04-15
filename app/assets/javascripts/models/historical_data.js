(function (app){
  app.models.HistoricalData = Backbone.Model.extend({
    initialize: function () {
      this.set('plants', []);
      this.set('herbivores', []);
      this.set('carnivores', []);

      this.get('tiles').on('reset', this.addNewDataPoints, this);
    },

    addNewDataPoints: function (collection) {
      var dataPointNumber = this.get('plants').length;
      this.get('plants').push([dataPointNumber, collection.plantCount()]);
      this.get('herbivores').push([dataPointNumber, collection.herbivoreCount()]);
      this.get('carnivores').push([dataPointNumber, collection.carnivoreCount()]);
      this.trigger('change');
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

    countFor: function (lifeType) {
      var list = this.get(lifeType);
      return list.length == 0 ? 0 : list[list.length - 1][1];
    }
  });
}(Alive));
