class MarkerView extends BaseView {
  constructor(options = {}) {
    super();
    this.viewClass = '.marker-view';
    this.app = options.app;
    $(document).ready(this.onDocumentReady.bind(this));
    this.deleteMarker = _.debounce(this._deleteMarker.bind(this), 250, true);
  }

  onDocumentReady() {
    this.createUIHash();
    this.bindHandlers();
    this.createEditor();
    if (!window.currentSphere) this.hide();
  }

  createUIHash() {
    this.ui = {
      $addMarker: $('#add-marker'),
      $resetMarker: $('#reset-marker'),
      $saveMarker: $('#save-marker'),
      $deleteMarker: $('#delete-marker'),
      $markerCaption: $('#marker_caption'),
      $markerContent: $('#marker_content'),
      $deleteExplanation: $('.delete-marker-explanation'),
      $markerContainer: $('.marker-container'),
    };
  }

  bindHandlers() {
    this.ui.$addMarker.click(this.onAddMarkerClick.bind(this));
    this.ui.$resetMarker.click(this.app.resetPageState.bind(this.app));
    this.ui.$saveMarker.click(this.onSaveMarkerClick.bind(this));
    this.ui.$deleteMarker.click(this.onDeleteMarkerClick.bind(this));
    this.ui.$markerCaption.keyup(_.debounce(this.onMarkerCaptionChange.bind(this)));
    this.ui.$markerContent.keyup(_.debounce(this.onMarkerContentChange.bind(this)));
  }

  bindPSV() {
    PSV.on('click', this.onPSVClick.bind(this));
    PSV.on('select-marker', this.onSelectMarker.bind(this));
  }

  createEditor() {
    // Try to initialize WYSIHTML5 if available
    if (this.ui.$markerContent.wysihtml5) {
      this.ui.$markerContent.wysihtml5({
        toolbar: { fa: true, lists: false, image: false },
        events: { 'save:dialog': this.onMarkerContentChange.bind(this) },
      });
      this.ui.$markerContentToolbar = $('.wysihtml5-toolbar');
      this.ui.$markerContentToolbar.click(() => _.defer(this.onMarkerContentChange.bind(this)));
      this.appendUploadButton();
    } else {
      this.ui.$markerContentToolbar = $();
    }
  }

  appendUploadButton() {
    const imageButton = `<li>
      <a id="add-photo" class="btn btn-default" tabindex="-1" href="javascript:;" unselectable="on">
        <span class="fa fa-image"></span> Photo
      </a>
    </li>`;
    $('.wysihtml5-toolbar').append(imageButton);
    $('#add-photo').click(this.onAddPhotoClick.bind(this));
  }

  resetViewState() {
    this.isCreatingMarker = false;
    this.isDeletingMarker = false;
    this.ui.$addMarker.prop('disabled', false);
    this.ui.$saveMarker.prop('disabled', true);
    this.ui.$resetMarker.prop('disabled', true);
    this.ui.$deleteMarker.prop('disabled', false);
    this.ui.$markerCaption.hide();
    this.ui.$markerContent.hide();
    if (this.ui.$markerContentToolbar) this.ui.$markerContentToolbar.hide();
    this.ui.$deleteExplanation.hide();
    this.removeSpinner();
    this.selectedPhotoPath = null;
    try { PSV.getMarker('new-marker'); } catch (e) { return; }
    PSV.removeMarker('new-marker');
  }

  freeze() {
    this.ui.$addMarker.prop('disabled', true);
    this.ui.$saveMarker.prop('disabled', true);
    this.ui.$resetMarker.prop('disabled', true);
    this.ui.$deleteMarker.prop('disabled', true);
    this.ui.$markerCaption.hide();
    this.ui.$markerContent.hide();
    if (this.ui.$markerContentToolbar) this.ui.$markerContentToolbar.hide();
    this.ui.$deleteExplanation.hide();
    this.isCreatingMarker = false;
    this.isDeletingMarker = false;
  }

  getEditorContent() {
    return this.ui.$markerContent.html();
  }

  formatEditorContent() {
    const imageRegex = /<img([\w\W]+?)>/;
    const raw = this.getEditorContent();
    if (raw.match(imageRegex)) {
      return raw.replace(imageRegex, '<!--IMGHERE-->');
    }
    this.selectedPhotoPath = null;
    return raw;
  }

  appendSpinner() {
    const spinner = new SpinnerView('marker', 'marker-spinner');
    this.ui.$markerContainer.hide();
    $(this.viewClass).append(spinner.render());
  }

  removeSpinner() {
    this.ui.$markerContainer.show();
    $('.marker-spinner').remove();
  }

  // Event Handlers

  onSelectMarker(marker, event) {
    if (marker.isNormal() && this.isDeletingMarker) {
      marker.content = '';
      this.deleteMarker(marker);
    }
  }

  onPSVClick(e) {
    if (this.isCreatingMarker) {
      try {
        const marker = PSV.getMarker('new-marker');
        PSV.updateMarker({ id: 'new-marker', x: e.texture_x, y: e.texture_y - this.verticalOffset });
      } catch (err) {
        const caption = this.ui.$markerCaption.val();
        PSV.addMarker({
          id: 'new-marker',
          x: e.texture_x,
          y: e.texture_y - this.verticalOffset,
          image: this.app.pinUrl,
          width: this.app.defaultMarkerDimension,
          height: this.app.defaultMarkerDimension,
          sphere_id: currentSphere.id,
          content: this.getEditorContent(),
          tooltip: caption ? { content: caption, position: 'right bottom' } : undefined,
        });
        this.ui.$saveMarker.prop('disabled', false);
        this.ui.$markerCaption.show();
        this.ui.$markerContent.show();
        if (this.ui.$markerContentToolbar) this.ui.$markerContentToolbar.show();
        this.ui.$markerCaption.focus();
      }
    }
  }

  onAddMarkerClick() {
    this.app.freezeOtherViews(this);
    this.app.setCursorToPencil();
    this.ui.$addMarker.prop('disabled', true);
    this.ui.$resetMarker.prop('disabled', false);
    this.ui.$deleteMarker.prop('disabled', true);
    this.ui.$markerContent.text('');
    this.ui.$markerCaption.val('');
    this.selectedPhotoPath = null;
    this.isCreatingMarker = true;
  }

  async onSaveMarkerClick() {
    const marker = PSV.getMarker('new-marker');
    this.app.resetCursor();
    this.appendSpinner();

    try {
      const savedRecord = await window.spherelinkAPI.createMarker({
        sphereId: currentSphere.id,
        x: marker.x,
        y: marker.y,
        width: this.app.defaultMarkerDimension,
        height: this.app.defaultMarkerDimension,
        tooltipContent: this.ui.$markerCaption.val(),
        content: this.formatEditorContent(),
        photoSourcePath: this.selectedPhotoPath || null,
      });

      PSV.removeMarker('new-marker', false);
      savedRecord.content = marker.content;
      PSV.addMarker(savedRecord);
      currentSphere.markers.push(savedRecord);
      this.app.resetPageState();
    } catch (e) {
      this.resetViewState();
      this.app.onAjaxError(e);
    }
  }

  onDeleteMarkerClick() {
    this.app.freezeOtherViews(this);
    this.ui.$deleteExplanation.show();
    this.ui.$addMarker.prop('disabled', true);
    this.ui.$resetMarker.prop('disabled', false);
    this.ui.$deleteMarker.prop('disabled', true);
    this.isDeletingMarker = true;
  }

  async _deleteMarker(marker) {
    const markerId = marker.id.split('-')[1];
    this.markerToDelete = marker;
    try {
      await window.spherelinkAPI.deleteMarker(parseInt(markerId));
      this.onDeleteMarkerSuccess();
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  cleanMarkerCache(marker) {
    const cached = _.findWhere(currentSphere.markers, { id: marker.id });
    const idx = currentSphere.markers.indexOf(cached);
    if (idx !== -1) currentSphere.markers.splice(idx, 1);
  }

  onMarkerCaptionChange() {
    const caption = this.ui.$markerCaption.val();
    if (caption) {
      PSV.updateMarker({ id: 'new-marker', tooltip: { content: caption, position: 'right bottom' } });
    } else {
      PSV.updateMarker({ id: 'new-marker', tooltip: null });
    }
  }

  onMarkerContentChange() {
    const content = this.getEditorContent();
    if (content) {
      PSV.updateMarker({ id: 'new-marker', content: content });
    } else {
      PSV.updateMarker({ id: 'new-marker', content: null });
    }
  }

  async onAddPhotoClick() {
    const filePath = await window.spherelinkAPI.showOpenDialog({
      properties: ['openFile'],
      filters: [{ name: 'Images', extensions: ['jpg', 'jpeg', 'png'] }],
    });
    if (filePath) {
      this.selectedPhotoPath = filePath;
      // Show preview
      const previewImage = "<img class='remove-me' src='file://" + filePath + "'>";
      $('#marker_content .remove-me').remove();
      $('#marker_content').append(previewImage);
      this.onMarkerContentChange();
      $('#marker_content').focus();
    }
  }

  // Callbacks

  onDeleteMarkerSuccess() {
    PSV.removeMarker(this.markerToDelete);
    this.cleanMarkerCache(this.markerToDelete);
    this.markerToDelete = null;
    this.app.resetPageState();
  }
}

// Constants
MarkerView.prototype.verticalOffset = 40;

window.MarkerView = MarkerView;
