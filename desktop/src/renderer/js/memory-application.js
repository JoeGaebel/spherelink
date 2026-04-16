class MemoryApplication {
  constructor(options = {}) {
    window.memory = options.memory;
    window.currentSphere = memory.spheres[options.sphereNum];

    $(this.onDocumentReady.bind(this));
  }

  _start() {
    this.setupSoundManager();
    window.PSV = new PhotoSphereViewer(this.getPSVOptions());
    this.bindHandlers();
  }

  start() {
    setTimeout(() => this._start(), 500);
  }

  bindHandlers() {
    PSV.on('ready', this.onPSVReady);
    PSV.on('fullscreen-updated', (enabled) => PSV.toggleNavbar());
    PSV.on('select-marker', this.onSelectMarker.bind(this));
  }

  // Helpers

  getPSVOptions() {
    return $.extend(
      {
        panorama: (window.currentSphere && window.currentSphere.panorama) || this.whiteImageUrl,
        caption: (window.currentSphere && window.currentSphere.caption) || '',
        markers: this.getPortalsAndMarkers(currentSphere),
      },
      this.defaultPanoramaSettings
    );
  }

  setupSoundManager() {
    soundManager.setup(this.defaultSoundManagerSettings);
    soundManager.onready(this.onSoundManagerReady.bind(this));
  }

  doTransition(portal) {
    const oldAnimation = PSV.stopAnimation;
    PSV.stopAnimation = function () {};

    const center = this.getCenter(portal.polygon_px);
    const associatedSphere = _.findWhere(window.memory.spheres, {
      id: parseInt(portal.to_sphere_id),
    });

    window.PSV.animate({ x: center[0], y: center[1] }, 1000).then(() => {
      this.setNextSphere(associatedSphere, portal);
      PSV.stopAnimation = oldAnimation;
    });
  }

  setNextSphere(sphere, portal) {
    if (!portal) portal = {};
    window.PSV.setPanorama(
      sphere.panorama,
      {
        latitude: portal.fov_lat || 0,
        longitude: portal.fov_lng || 0,
      },
      true
    ).then(() => this._setNextSphereMakers(sphere));
  }

  _setNextSphereMakers(sphere) {
    PSV.setCaption(sphere.caption);
    PSV.zoom(sphere.defaultZoom);
    PSV.clearMarkers();
    const markers = this.getPortalsAndMarkers(sphere);
    for (const marker of markers) {
      PSV.addMarker(marker);
    }
    this.playSound(sphere);
    window.currentSphere = sphere;
  }

  getPortalsAndMarkers(sphere) {
    if (!sphere) return [];
    return sphere.markers.concat(sphere.portals);
  }

  playSound(sphere) {
    if (sphere.sound) {
      if (memory.defaultSound) {
        soundManager.mute(memory.defaultSound.id);
      }
      if (soundManager.getSoundById(sphere.sound.id)) {
        soundManager.play(sphere.sound.id).unmute();
      } else {
        this.createSound(sphere.sound).play();
      }
    } else {
      soundManager.pauseAll();
      if (memory.defaultSound) {
        soundManager.play(memory.defaultSound.id).unmute();
      }
    }
  }

  getCenter(array) {
    const imageWidth = PSV.prop.pano_data.full_width;
    const x = array.map((a) => a[0]);
    const y = array.map((a) => a[1]);
    const minX = Math.min.apply(null, x);
    const maxX = Math.max.apply(null, x);
    const minY = Math.min.apply(null, y);
    const maxY = Math.max.apply(null, y);

    const centerY = (minY + maxY) / 2;

    const insideCenterX = (minX + maxX) / 2;
    const insideAvgX = insideCenterX - minX;

    const outsideAvgX = (imageWidth - maxX + minX) / 2;
    const outsideOffset = maxX;
    const outsideCenterX = (outsideAvgX + outsideOffset) % imageWidth;

    if (insideAvgX > outsideAvgX) {
      return [outsideCenterX, centerY];
    } else {
      return [insideCenterX, centerY];
    }
  }

  createSound(soundConfig) {
    return soundManager.createSound(
      _.extend({}, this.defaultSoundSettings, soundConfig)
    );
  }

  // Event Handlers

  onSoundManagerReady() {
    if (memory.defaultSound) {
      this.createSound(memory.defaultSound).play();
    }
  }

  onSelectMarker(marker) {
    if (marker.isPolygon()) {
      this.doTransition(marker);
    }
  }

  onPSVReady() {
    PSV.setCaption((currentSphere && currentSphere.caption) || '');
    setTimeout(() => PSV.zoom((currentSphere && currentSphere.defaultZoom) || 50), 1);
  }

  onDocumentReady() {
    if (!window.currentSphere) {
      $('#photosphere').hide();
    }
  }
}

// Constants as prototype properties
MemoryApplication.prototype.pinUrl = './images/pin2.png';

MemoryApplication.prototype.defaultPanoramaSettings = {
  loading_img: './images/photosphere-logo.gif',
  navbar: [
    {
      title: 'Fullscreen',
      content: '<i class="glyphicon glyphicon-fullscreen"></i>',
      onClick: () => window.PSV.toggleFullscreen(),
      className: 'full-screen',
    },
    'caption',
  ],
  sphere_segments: 128,
  container: 'photosphere',
  anim_speed: '-0.5rpm',
  time_anim: 0,
  default_fov: 20,
  move_speed: 1.8,
  fisheye: false,
  gyroscope: false,
  webgl: true,
  cache_texture: 10,
  size: {
    height: 554,
    width: null,
  },
  transition: {
    duration: 0,
    loader: true,
    blur: true,
  },
};

MemoryApplication.prototype.defaultSoundManagerSettings = {
  preferFlash: false,
  debugMode: false,
  debugFlash: false,
  useHTML5Audio: true,
};

MemoryApplication.prototype.defaultSoundSettings = {
  autoLoad: true,
  autoPlay: false,
};

MemoryApplication.prototype.whiteImageUrl = './images/white.jpg';

window.MemoryApplication = MemoryApplication;
