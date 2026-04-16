class ZoomView extends BaseView {
  constructor(options = {}) {
    super();
    this.viewClass = '.zoom-view';
    this.app = options.app;
    $(document).ready(this.onDocumentReady.bind(this));
  }

  onDocumentReady() {
    this.createUIHash();
    this.bindHandlers();
    this.resetSliderValue();
    if (!window.currentSphere) this.hide();
  }

  createUIHash() {
    this.ui = {};
    this.ui.$slider = $('#default_zoom');
    this.ui.slider = this.ui.$slider.slider();
  }

  bindHandlers() {
    this.ui.slider.on('change', this.onSliderChange.bind(this));
    this.ui.slider.on('slideStop', this.saveZoomLevel.bind(this));
  }

  resetSliderValue() {
    this.ui.$slider.slider('setValue', (currentSphere && currentSphere.defaultZoom) || 50);
  }

  getLevel() {
    return parseInt(this.ui.$slider.val());
  }

  onSliderChange() {
    PSV.zoom(this.getLevel());
  }

  async saveZoomLevel() {
    const level = this.getLevel();
    currentSphere.defaultZoom = level;
    try {
      await window.spherelinkAPI.updateZoom(currentSphere.id, level);
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }
}

window.ZoomView = ZoomView;
