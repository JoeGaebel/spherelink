class AddSphereView {
  constructor(options = {}) {
    this.app = options.app;
    $(document).ready(this.onDocumentReady.bind(this));
  }

  onDocumentReady() {
    this.createUIHash();
    this.bindHandlers();
  }

  createUIHash() {
    this.ui = {
      $addSphereButton: $('.add-button'),
      $addForm: $('.add-form'),
      $submit: $('#upload-submit'),
      $cancel: $('#upload-cancel'),
      $caption: $('.sphere-caption'),
      $fileForm: $('.file-form'),
      $captionForm: $('.caption-form'),
    };
  }

  bindHandlers() {
    this.ui.$addSphereButton.click(this.onAddSphereButtonClick.bind(this));
    this.ui.$cancel.click(this.resetWidget.bind(this));
    this.ui.$submit.click(this.onSubmitClick.bind(this));
  }

  resetWidget(event) {
    this.ui.$addForm.hide();
    this.ui.$addSphereButton.show();
    this.selectedFilePath = null;
    if (event) event.stopPropagation();
  }

  async newSphere() {
    if (!this.selectedFilePath) return;

    // Capture inputs before resetWidget() nulls them
    const filePath = this.selectedFilePath;
    const caption = this.ui.$caption.val();

    const spinnerID = chance.guid();
    this.appendSpinner(spinnerID);
    this.resetWidget();

    try {
      const sphere = await window.spherelinkAPI.createSphere(
        window.memory.id,
        caption,
        filePath
      );
      window.memory.spheres.push(sphere);
      this.resetViewState(spinnerID);
      this.app.handleNewSphere();
    } catch (e) {
      this.app.onAjaxError(e);
      this.resetViewState(spinnerID);
    }
  }

  appendSpinner(id) {
    const $addSphereLink = $('.add-sphere-link');
    const html = new SpinnerView(id, 'sphere-item-view').render();
    $(html).insertBefore($addSphereLink);
  }

  removeSpinner(id) {
    if (id) {
      $(`#spinner-${id}`).remove();
    } else {
      $('.spinner').remove();
    }
  }

  resetViewState(id) {
    this.removeSpinner(id);
  }

  clearInputs() {
    this.ui.$caption.val('');
    this.selectedFilePath = null;
    $('#selected-file-name').text('');
  }

  onAddSphereButtonClick() {
    this.ui.$addForm.show();
    this.ui.$addSphereButton.hide();
    this.clearInputs();
  }

  async onSubmitClick() {
    if (!this.selectedFilePath) {
      // Open file dialog
      const filePath = await window.spherelinkAPI.showOpenDialog({
        properties: ['openFile'],
        filters: [{ name: 'Panorama Images', extensions: ['jpg', 'jpeg'] }],
      });
      if (filePath) {
        this.selectedFilePath = filePath;
        this.ui.$fileForm.removeClass('has-error');
      } else {
        this.ui.$fileForm.addClass('has-error');
        return;
      }
    }

    if (!this.ui.$caption.val()) {
      this.ui.$captionForm.addClass('has-error');
      return;
    }

    this.ui.$fileForm.removeClass('has-error');
    this.ui.$captionForm.removeClass('has-error');
    this.newSphere();
  }
}

window.AddSphereView = AddSphereView;
