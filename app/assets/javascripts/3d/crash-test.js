(function ($) {

  var CUBE_SIZE = 15;
  var TILE_SIZE = 35;

  window.CrashTest = function() {
    this.init();

    this.addTiles();
    this.addRandomCubes(1000);
    this.render();
  };

  window.CrashTest.prototype = {
    init:function() {
      this.cubes = [];

      this.scene = new THREE.Scene();

      this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.set(0, -400, 500);
      this.camera.lookAt(new THREE.Vector3(0, 500, 0));
      this.scene.add(this.camera);

      var sunLight = new THREE.SpotLight(0xffffff);
      sunLight.position.set(200, 700, 300);
      sunLight.castShadow = true;
      this.scene.add(sunLight);

      this.renderer = new THREE.WebGLRenderer();
      this.renderer.shadowMapEnabled = true;
      this.renderer.setSize(window.innerWidth, window.innerHeight);

      document.body.appendChild(this.renderer.domElement);
    },

    start:function() {
      var self = this;

      this.interval = setInterval(function () {
        self.removeRandomCubes(50);
        self.addRandomCubes(50);
        self.render();
      }, 0);
    },

    stop:function() {
      clearInterval(this.interval);
      this.interval = null;
    },

    toggle:function() {
      if (this.interval) {
        this.stop();
        return false;
      } else {
        this.start();
        return true;
      }
    },

    render: function() {
      this.renderer.render(this.scene, this.camera);
    },

    addTiles:function() {
      for (var i = -15; i < 15; i++) {
        for (var j = 0; j < 30; j++) {
          var geometry = new THREE.PlaneGeometry(TILE_SIZE, TILE_SIZE, 1, 1);
          var material = new THREE.MeshLambertMaterial({ color:0xffcc00, wireframe:WIREFRAME });

          var mesh = new THREE.Mesh(geometry, material);
          mesh.position.set(i * TILE_SIZE, j * TILE_SIZE, 0);
          mesh.receiveShadow = true;

          this.scene.add(mesh);
        }
      }
    },

    removeRandomCubes:function(count) {
      for (var i = 0; i < count; i++) {
        var mesh = this.cubes.shift();
        this.scene.remove(mesh);
      }
    },

    addRandomCubes:function(count) {
      for (var i = 0; i < count; i++) {
        var geometry = new THREE.CubeGeometry(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
        var material = new THREE.MeshLambertMaterial({ color:0x990000 });

        var x = (Math.random() - 0.5) * 1000;
        var y = Math.random() * 1000;
        var z = CUBE_SIZE / 2;

        var mesh = new THREE.Mesh(geometry, material);
        mesh.position.set(x, y, z);

        mesh.castShadow = true;
        mesh.receiveShadow = true;

        this.scene.add(mesh);

        this.cubes.push(mesh);
      }
    }
  }

})(jQuery);