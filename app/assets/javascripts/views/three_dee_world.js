(function (app) {
  WIREFRAME = false;

  app.views.ThreeDeeWorld = Backbone.View.extend({
    tilesAdded: false,
    tileSize: 100,
    entitySize: 10,
    lifeColors: {
      'plant': 0x90ee90,
      'herbivore': 0xd1b38b,
      'carnivore': 0xbb0000
    },

    initialize: function () {
      this.knownLife = {};

      this.scene = new THREE.Scene();

      this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.set(500, -400, 500);
      this.camera.lookAt(new THREE.Vector3(500, 500, 0));
      this.scene.add(this.camera);

      var sunLight = new THREE.SpotLight(0xffffff);
      sunLight.position.set(this.tileSize * 5, this.tileSize * 5, this.tileSize * 3);
      sunLight.castShadow = true;
      this.scene.add(sunLight);

      var geometry = new THREE.CubeGeometry(200, 200, 200);
      var material = new THREE.MeshBasicMaterial({ color: 0xff0000, wireframe: true });

      this.cubeMesh = new THREE.Mesh(geometry, material);
      this.scene.add(this.cubeMesh);

      this.renderer = new THREE.WebGLRenderer();
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      this.renderer.shadowMapEnabled = true;

      this.el = this.renderer.domElement;

      this.collection.on('reset', this.render, this);
    },

    render: function () {
      this.ensureTilesExist();
      var added = this.addNewLife();
      var deleted = this.removeDeadLife();

      console.log("added: " + added + "; deleted: " + deleted);

      this.cubeMesh.rotation.x += 0.01;
      this.cubeMesh.rotation.y += 0.02;

      this.renderer.render(this.scene, this.camera);
    },

    ensureTilesExist: function () {
      if (!this.tilesAdded) {
        this.collection.each(function (tile) {
          var geometry = new THREE.PlaneGeometry(this.tileSize, this.tileSize, 1, 1);
          var material = new THREE.MeshLambertMaterial({ color: 0xffcc00, wireframe: WIREFRAME });

          var mesh = new THREE.Mesh(geometry, material);
          mesh.position.set(tile.x(this.tileSize), tile.y(this.tileSize), 0);
          mesh.receiveShadow = true;

          this.scene.add(mesh);
        }.bind(this));
      }
      this.tilesAdded = true;
    },

    addNewLife: function () {
      var bornThisTurn = 0;
      this.collection.each(function (tile) {
        _(tile.allLife()).each(function (entity) {
          if (!this.knownLife[entity.id]) {
            var geometry = new THREE.CubeGeometry(this.entitySize, this.entitySize, this.entitySize);
            var material = new THREE.MeshLambertMaterial({ color: this.lifeColors[entity.get('lifeType')], wireframe: WIREFRAME });

            var mesh = new THREE.Mesh(geometry, material);
            var x = tile.x(this.tileSize) + ((entity.get('x') - 0.5) * this.tileSize);
            var y = tile.y(this.tileSize) + ((entity.get('y') - 0.5) * this.tileSize);

            mesh.position.set(x, y, this.entitySize / 2);
            mesh.castShadow = true;
            mesh.receiveShadow = true;

            this.scene.add(mesh);

            this.knownLife[entity.id] = { id: entity.id, mesh: mesh, stillAlive: true };
            bornThisTurn++;
          }
          this.knownLife[entity.id].stillAlive = true;
        }.bind(this));
      }.bind(this));

      return bornThisTurn;
    },

    removeDeadLife: function () {
      var diedThisTurn = [];

      _(this.knownLife).chain().values().each(function (life) {
        if (!life.stillAlive) {
          diedThisTurn.push(life.id);
        }
        life.stillAlive = false;
      });

      _(diedThisTurn).each(function (entityId) {
        this.scene.remove(this.knownLife[entityId].mesh);

        delete this.knownLife[entityId];
      }.bind(this));

      return diedThisTurn.length;
    }
  });
}(Alive));
