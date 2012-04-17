(function ($) {

  WIREFRAME = false;

  var TILE_SIZE = 100;
  var ENTITY_SIZE = 10;

  window.ThreeDeeWorld = function () {
    this.init();
    this.animate();
    this.fetchTiles();
  };

  window.ThreeDeeWorld.prototype = {
    init:function () {
      this.scene = new THREE.Scene();

      this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.set(500, -400, 500);
      this.camera.lookAt(new THREE.Vector3(500, 500, 0));
      this.scene.add(this.camera);

      var geometry = new THREE.CubeGeometry(200, 200, 200);
      var material = new THREE.MeshBasicMaterial({ color:0xff0000, wireframe:true });

      this.cubeMesh = new THREE.Mesh(geometry, material);
      this.scene.add(this.cubeMesh);

      this.renderer = new THREE.WebGLRenderer();
      this.renderer.setSize(window.innerWidth, window.innerHeight);

      document.body.appendChild(this.renderer.domElement);
    },

    animate:function () {
      // note: three.js includes requestAnimationFrame shim
      requestAnimationFrame(this.animate.bind(this));
      this.render();
    },

    render:function () {
      this.cubeMesh.rotation.x += 0.01;
      this.cubeMesh.rotation.y += 0.02;

      this.renderer.render(this.scene, this.camera);
    },

    addTilesToScene:function (tiles) {
      for (var i = 0; i < tiles.length; i++) {
        var tile = tiles[i];
        var geometry = new THREE.PlaneGeometry(TILE_SIZE, TILE_SIZE, 1, 1);
        var material = new THREE.MeshBasicMaterial({ color:0xffcc00, wireframe:WIREFRAME });

        var tileMesh = new THREE.Mesh(geometry, material);
        var tileX = tile.x * TILE_SIZE;
        var tileY = tile.y * TILE_SIZE;
        tileMesh.position.set(tileX, tileY, 0);

        this.scene.add(tileMesh);

        this.addEntitiesToScene(tile.plants, 0x90ee90, tileX, tileY);
        this.addEntitiesToScene(tile.herbivores, 0xd1b38b, tileX, tileY);
        this.addEntitiesToScene(tile.carnivores, 0xbb0000, tileX, tileY);
      }
    },

    addEntitiesToScene:function (entities, color, tileX, tileY) {
      $.each(entities, function (i, entity) {
        var geometry = new THREE.CubeGeometry(ENTITY_SIZE, ENTITY_SIZE, ENTITY_SIZE);
        var material = new THREE.MeshBasicMaterial({ color:color, wireframe:WIREFRAME });

        var plantMesh = new THREE.Mesh(geometry, material);
        var x = tileX + ((entity.x - 0.5) * TILE_SIZE);
        var y = tileY + ((entity.y - 0.5) * TILE_SIZE);
        plantMesh.position.set(x, y, ENTITY_SIZE / 2);

        this.scene.add(plantMesh);
      }.bind(this));
    },

    fetchTiles:function () {
      var self = this;
      $.ajax({
        url:'/worlds/current.json',
        success:function (response) {
          self.addTilesToScene(response.tiles);
        }
      })
    }
  };


}(jQuery));