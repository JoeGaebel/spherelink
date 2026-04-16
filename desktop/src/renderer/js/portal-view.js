class PortalView extends BaseView {
  constructor(options = {}) {
    super();
    this.viewClass = '.portal-view';
    this.app = options.app;
    $(document).ready(this.onDocumentReady.bind(this));
    this.deletePortal = _.debounce(this._deletePortal.bind(this), 250, true);
  }

  onDocumentReady() {
    this.createUIHash();
    this.bindHandlers();
    this.updateSelect();
    if (!window.currentSphere) this.hide();
  }

  createUIHash() {
    this.ui = {
      $addPortal: $('#start-portal'),
      $resetPortal: $('#reset-portal'),
      $savePortal: $('#save-portal'),
      $toSphereSelect: $('#to_sphere_id'),
      $portalCaption: $('#portal_caption'),
      $deletePortal: $('#delete-portal'),
      $deleteExplanation: $('.delete-portal-explanation'),
    };
  }

  bindHandlers() {
    this.ui.$addPortal.click(this.onAddPortalClicked.bind(this));
    this.ui.$resetPortal.click(this.app.resetPageState.bind(this.app));
    this.ui.$savePortal.click(this.onSavePortalClicked.bind(this));
    this.ui.$deletePortal.click(this.onDeleteClick.bind(this));
    this.ui.$portalCaption.keyup(_.debounce(this.onPortalCaptionChanged.bind(this), 300));
    this.ui.$toSphereSelect.change(this.onToSphereSelectChanged.bind(this));
  }

  bindPSV() {
    PSV.on('click', this.onPSVClick.bind(this));
    PSV.on('select-marker', this.onSelectMarker.bind(this));
  }

  updateSelect() {
    this.ui.$toSphereSelect.children().remove();
    for (const sphere of memory.spheres) {
      if (currentSphere.id === sphere.id) continue;
      this.ui.$toSphereSelect.append($('<option>', { value: sphere.id, text: sphere.caption }));
    }
    this.onToSphereSelectChanged();
  }

  getPortalParams(portal) {
    return {
      fromSphereId: window.currentSphere.id,
      toSphereId: parseInt(portal.to_sphere_id),
      polygonPx: portal.polygon_px,
      tooltipContent: portal.tooltip ? portal.tooltip.content : null,
    };
  }

  async _deletePortal(portal) {
    const portalId = portal.id.split('-')[1];
    this.portalToDelete = portal;
    try {
      await window.spherelinkAPI.deletePortal(parseInt(portalId));
      this.onDeletePortalSuccess();
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  cleanPortalCache(portal) {
    const cachedPortal = _.findWhere(currentSphere.portals, { id: portal.id });
    const idx = currentSphere.portals.indexOf(cachedPortal);
    if (idx !== -1) currentSphere.portals.splice(idx, 1);
  }

  resetViewState() {
    this.isCreatingPortal = false;
    this.isDeletingPortal = false;
    this.ui.$addPortal.prop('disabled', false);
    this.ui.$savePortal.prop('disabled', true);
    this.ui.$resetPortal.prop('disabled', true);
    this.ui.$deletePortal.prop('disabled', false);
    this.ui.$toSphereSelect.hide();
    this.ui.$portalCaption.hide();
    this.ui.$deleteExplanation.hide();
    try { PSV.getMarker('new-portal'); } catch (e) { return; }
    PSV.removeMarker('new-portal');
  }

  freeze() {
    this.ui.$addPortal.prop('disabled', true);
    this.ui.$savePortal.prop('disabled', true);
    this.ui.$resetPortal.prop('disabled', true);
    this.ui.$deletePortal.prop('disabled', true);
    this.ui.$toSphereSelect.hide();
    this.ui.$portalCaption.hide();
    this.ui.$deleteExplanation.hide();
    this.isCreatingPortal = false;
    this.isDeletingPortal = false;
  }

  canSavePortal(portal) {
    return portal.polygon_px.length > 2 && this.ui.$toSphereSelect.val();
  }

  // Event Handlers

  onSelectMarker(marker) {
    if (marker.isPolygon()) {
      if (!this.app.promptForTransition()) return;
      if (this.isDeletingPortal) { this.deletePortal(marker); }
      if (!this.isCreatingPortal && !this.isDeletingPortal) { this.app.doTransition(marker); }
    }
  }

  onPSVClick(e) {
    if (this.isCreatingPortal) {
      const newPortal = PSV.getMarker('new-portal');
      if (!newPortal.polygon_px[0].length) newPortal.polygon_px = [];
      newPortal.polygon_px.push([e.texture_x, e.texture_y]);
      PSV.updateMarker(newPortal, true);
      if (this.canSavePortal(newPortal)) this.ui.$savePortal.prop('disabled', false);
    }
  }

  onAddPortalClicked() {
    this.app.freezeOtherViews(this);
    this.app.setCursorToPencil();
    this.ui.$addPortal.prop('disabled', true);
    this.ui.$resetPortal.prop('disabled', false);
    this.ui.$toSphereSelect.show();
    this.ui.$portalCaption.show();
    this.ui.$portalCaption.val('');
    this.ui.$deletePortal.prop('disabled', true);
    this.isCreatingPortal = true;
    const caption = this.ui.$portalCaption.val();
    PSV.addMarker({
      id: 'new-portal',
      polygon_px: [[]],
      to_sphere_id: this.ui.$toSphereSelect.val(),
      tooltip: caption ? { content: caption, position: 'right bottom' } : undefined,
      svgStyle: { fill: 'url(#points)', stroke: 'rgba(255, 50, 50, 0.8)', 'stroke-width': '2px' },
    });
  }

  onToSphereSelectChanged() {
    if (this.isCreatingPortal) {
      const newPortal = PSV.getMarker('new-portal');
      newPortal.to_sphere_id = this.ui.$toSphereSelect.val();
      PSV.updateMarker(newPortal);
      if (this.canSavePortal(newPortal)) this.ui.$savePortal.prop('disabled', false);
    }
  }

  async onSavePortalClicked() {
    const portal = PSV.getMarker('new-portal');
    this.app.resetCursor();
    try {
      const savedRecord = await window.spherelinkAPI.createPortal(this.getPortalParams(portal));
      PSV.removeMarker('new-portal', false);
      PSV.addMarker(savedRecord);
      currentSphere.portals.push(savedRecord);
      this.app.resetPageState();
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  onPortalCaptionChanged() {
    if (this.isCreatingPortal) {
      const newPortal = PSV.getMarker('new-portal');
      const caption = this.ui.$portalCaption.val();
      if (caption) {
        newPortal.tooltip = { content: caption, position: 'right bottom' };
      } else {
        delete newPortal.tooltip;
      }
      PSV.updateMarker(newPortal);
    }
  }

  onDeleteClick() {
    this.app.freezeOtherViews(this);
    this.ui.$deleteExplanation.show();
    this.ui.$addPortal.prop('disabled', true);
    this.ui.$resetPortal.prop('disabled', false);
    this.ui.$deletePortal.prop('disabled', true);
    this.isDeletingPortal = true;
  }

  // Callbacks

  onDeletePortalSuccess() {
    PSV.removeMarker(this.portalToDelete);
    this.cleanPortalCache(this.portalToDelete);
    this.portalToDelete = null;
    this.app.resetPageState();
  }
}

window.PortalView = PortalView;
