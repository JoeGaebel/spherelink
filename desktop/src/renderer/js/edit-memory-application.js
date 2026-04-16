class EditMemoryApplication extends MemoryApplication {
  constructor(options = {}) {
    super(options);
    this.portalView = new PortalView({ app: this });
    this.markerView = new MarkerView({ app: this });
    this.sphereSelectView = new SphereSelectView({ app: this });
    this.zoomView = new ZoomView({ app: this });
    this.addSphereView = new AddSphereView({ app: this });
    this.headerView = new HeaderView({ app: this });

    this.views = [this.portalView, this.markerView];
    this.viewsToHide = [this.portalView, this.markerView, this.zoomView];
  }

  bindHandlers() {
    super.bindHandlers();
    PSV.off('select-marker');
    for (const view of this.views) {
      view.bindPSV();
    }
  }

  // Helpers

  handleEmptyPage() {
    if (window.currentSphere) {
      $('#empty-sphere-state').hide();
      $('.edit-row').show();
      return;
    }
    $('.link-viewer').hide();
    $('.edit-row').hide();
    $('#empty-sphere-state').show();
    for (const view of this.viewsToHide) {
      view.hide();
    }
  }

  setUpPSV() {
    $('#empty-sphere-state').hide();
    $('.edit-row').show();
    $('.link-viewer').show();
    window.currentSphere = window.memory.spheres[0];
    this._preload(currentSphere.panorama);
    this.setNextSphere(window.currentSphere);
    for (const view of this.viewsToHide) {
      view.show();
    }
  }

  _preload(url) {
    const image = new Image();
    image.src = url;
  }

  getPSVOptions() {
    return $.extend(super.getPSVOptions(), this.editPanoramaSettings);
  }

  _setNextSphereMakers(sphere) {
    super._setNextSphereMakers(sphere);
    this.portalView.updateSelect();
    this.zoomView.resetSliderValue();
  }

  freezeOtherViews(except) {
    const viewsToFreeze = _.reject(this.views, (view) => view instanceof except.constructor);
    for (const view of viewsToFreeze) {
      view.freeze();
    }
  }

  unfreezeOtherViews(except) {
    const viewsToUnfreeze = _.reject(this.views, (view) => view instanceof except.constructor);
    for (const view of viewsToUnfreeze) {
      view.resetViewState();
    }
  }

  resetPageState() {
    this.resetCursor();
    for (const view of this.views) {
      view.resetViewState();
    }
  }

  handleNewSphere() {
    if (!window.currentSphere) {
      this.setUpPSV();
    }
    this.sphereSelectView.renderSpheres();
    this.portalView.updateSelect();
  }

  doTransition() {
    super.doTransition(...arguments);
    this.resetPageState();
  }

  setCursorToPencil() {
    try {
      $('.psv-hud').awesomeCursor('pencil', {
        hotspot: [3, 22],
        outline: 'white',
      });
    } catch (e) {
      // awesomeCursor may not be available
      $('.psv-hud').css('cursor', 'crosshair');
    }
  }

  resetCursor() {
    $('.psv-hud').css('cursor', 'move');
  }

  hackThePencil() {
    $('body').append("<i class='fa fa-pencil' style='width:0px; height:0px; overflow:hidden'>");
  }

  promptForTransition() {
    if (this.markerView.isCreatingMarker) {
      return confirm("Looks like you're creating a marker, are you sure you wish to leave? Unsaved marker content will be lost.");
    } else if (this.portalView.isCreatingPortal) {
      return confirm("Looks like you're creating a portal, are you sure you wish to leave? Unsaved portal settings will be lost.");
    }
    return true;
  }

  onDocumentReady() {
    this.hackThePencil();
    this.handleEmptyPage();
  }

  // Error handler
  onAjaxError(error) {
    const message = (error && error.message) || 'An unexpected error occurred.';
    alert('Error: ' + message);
  }
}

// Constants
EditMemoryApplication.prototype.defaultMarkerDimension = 32;

EditMemoryApplication.prototype.editPanoramaSettings = {
  anim_speed: '0rpm',
};

window.EditMemoryApplication = EditMemoryApplication;
