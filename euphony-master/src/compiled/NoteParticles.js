// Generated by CoffeeScript 1.10.0
(function() {
  var NoteParticles,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  NoteParticles = (function() {
    NoteParticles.prototype.count = 30;

    NoteParticles.prototype.size = 0.2;

    NoteParticles.prototype.life = 10;

    function NoteParticles(pianoDesign) {
      var color, j, keyInfo, note, noteToColor, ref, ref1;
      this.pianoDesign = pianoDesign;
      this.createParticles = bind(this.createParticles, this);
      this.update = bind(this.update, this);
      ref = this.pianoDesign, noteToColor = ref.noteToColor, keyInfo = ref.keyInfo;
      this.model = new THREE.Object3D();
      this.materials = [];
      for (note = j = 0, ref1 = keyInfo.length; 0 <= ref1 ? j < ref1 : j > ref1; note = 0 <= ref1 ? ++j : --j) {
        color = noteToColor(note);
        this.materials[note] = new THREE.PointCloudMaterial({
          size: this.size,
          map: this._generateTexture(color),
          blending: THREE.AdditiveBlending,
          transparent: true,
          depthWrite: false,
          color: color
        });
      }
    }

    NoteParticles.prototype._generateTexture = function(hexColor) {
      var canvas, context, gradient, height, texture, width;
      width = 32;
      height = 32;
      canvas = document.createElement('canvas');
      canvas.width = width;
      canvas.height = height;
      width = canvas.width, height = canvas.height;
      context = canvas.getContext('2d');
      gradient = context.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2);
      gradient.addColorStop(0, (new THREE.Color(hexColor)).getStyle());
      gradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
      context.fillStyle = gradient;
      context.fillRect(0, 0, width, height);
      texture = new THREE.Texture(canvas, THREE.UVMapping, THREE.ClampToEdgeWrapping, THREE.ClampToEdgeWrapping, THREE.NearestFilter, THREE.LinearMipMapLinearFilter);
      texture.needsUpdate = true;
      return texture;
    };

    NoteParticles.prototype.update = function() {
      var j, k, len, len1, particle, particleSystem, ref, ref1, results;
      ref = this.model.children.slice(0);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        particleSystem = ref[j];
        if (particleSystem.age++ > this.life) {
          results.push(this.model.remove(particleSystem));
        } else {
          ref1 = particleSystem.geometry.vertices;
          for (k = 0, len1 = ref1.length; k < len1; k++) {
            particle = ref1[k];
            particle.add(particle.velocity);
          }
          results.push(particleSystem.geometry.verticesNeedUpdate = true);
        }
      }
      return results;
    };

    NoteParticles.prototype.createParticles = function(note) {
      var Black, KeyType, geometry, i, j, keyCenterPosX, keyInfo, keyType, material, particle, particleSystem, posX, posY, posZ, ref, ref1, ref2;
      ref = this.pianoDesign, keyInfo = ref.keyInfo, KeyType = ref.KeyType;
      Black = KeyType.Black;
      ref1 = keyInfo[note], keyCenterPosX = ref1.keyCenterPosX, keyType = ref1.keyType;
      posX = keyCenterPosX;
      posY = keyType === Black ? 0.18 : 0.13;
      posZ = -0.2;
      geometry = new THREE.Geometry();
      for (i = j = 0, ref2 = this.count; 0 <= ref2 ? j < ref2 : j > ref2; i = 0 <= ref2 ? ++j : --j) {
        particle = new THREE.Vector3(posX, posY, posZ);
        particle.velocity = new THREE.Vector3((Math.random() - 0.5) * 0.04, (Math.random() - 0.3) * 0.01, (Math.random() - 0.5) * 0.04);
        geometry.vertices.push(particle);
      }
      material = this.materials[note];
      particleSystem = new THREE.PointCloud(geometry, material);
      particleSystem.age = 0;
      particleSystem.transparent = true;
      particleSystem.opacity = 0.8;
      return this.model.add(particleSystem);
    };

    return NoteParticles;

  })();

  this.NoteParticles = NoteParticles;

}).call(this);
