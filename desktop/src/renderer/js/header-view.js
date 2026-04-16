class HeaderView {
  constructor(options = {}) {
    this.app = options.app;
    $(document).ready(this.onDocumentReady.bind(this));
    this.debouncedSetTitle = _.debounce(this._setTitle.bind(this), 250, true);
    this.debouncedSetDescription = _.debounce(this._setDescription.bind(this), 250, true);
  }

  onDocumentReady() {
    this.createUIHash();
    this.bindHandlers();
    this.setDefaultDescription();
  }

  createUIHash() {
    this.ui = {
      $titleWidget: $('.title-widget'),
      $descriptionWidget: $('.description-widget'),
      $titleLabel: $('#title'),
      $descriptionLabel: $('#description'),
      $titleInput: $('#title-input'),
      $descriptionInput: $('#description-input'),
    };
  }

  bindHandlers() {
    this.ui.$titleLabel.click(this.onTitleLabelClick.bind(this));
    this.ui.$descriptionLabel.click(this.onDescriptionLabelClick.bind(this));
    this.ui.$titleInput.blur(this.debouncedSetTitle);
    this.ui.$titleInput.keydown(this.onTitleInputKeydown.bind(this));
    this.ui.$descriptionInput.blur(this.debouncedSetDescription);
    this.ui.$descriptionInput.keydown(this.onDescriptionInputKeydown.bind(this));
  }

  setDefaultDescription() {
    if (this.ui.$descriptionLabel.text() === '') {
      this.ui.$descriptionLabel.text('Click to add a description');
    }
  }

  async _setTitle() {
    this.ui.$titleInput.hide();
    const spinner = new SmallSpinnerView();
    this.ui.$titleWidget.append(spinner.render());
    setTimeout(() => $('.title-widget .small-spinner').show(), 500);

    const name = this.ui.$titleInput.val();
    try {
      const response = await window.spherelinkAPI.updateMemory(window.memory.id, { name });
      this.clearTitleSpinner(response);
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  async _setDescription() {
    this.ui.$descriptionInput.hide();
    const spinner = new SmallSpinnerView();
    this.ui.$descriptionWidget.append(spinner.render());
    setTimeout(() => $('.description-widget .small-spinner').show(), 500);

    const description = this.ui.$descriptionInput.val();
    try {
      const response = await window.spherelinkAPI.updateMemory(window.memory.id, { description });
      this.clearDescriptionSpinner(response);
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  clearTitleSpinner(response) {
    $('.title-widget .small-spinner').remove();
    this.ui.$titleLabel.text(response.name);
    this.ui.$titleInput.val(response.name);
    this.ui.$titleInput.hide();
    this.ui.$titleLabel.show();
  }

  clearDescriptionSpinner(response) {
    $('.description-widget .small-spinner').remove();
    this.ui.$descriptionLabel.text(response.description);
    this.ui.$descriptionInput.val(response.description);
    this.ui.$descriptionInput.hide();
    this.ui.$descriptionLabel.show();
  }

  // Event Handlers

  onTitleLabelClick() {
    this.ui.$titleInput.val(this.ui.$titleLabel.text());
    this.ui.$titleInput.css({ height: this.ui.$titleLabel.css('height') });
    this.ui.$titleWidget.css({ 'min-height': this.ui.$titleLabel.css('height') });
    this.ui.$titleInput.show();
    this.ui.$titleInput.focus();
    this.ui.$titleInput.select();
    this.ui.$titleLabel.hide();
  }

  onDescriptionLabelClick() {
    this.ui.$descriptionInput.val(this.ui.$descriptionLabel.text());
    this.ui.$descriptionInput.css({ height: this.ui.$descriptionLabel.css('height') });
    this.ui.$descriptionWidget.css({ 'min-height': this.ui.$descriptionLabel.css('height') });
    this.ui.$descriptionInput.show();
    this.ui.$descriptionInput.focus();
    this.ui.$descriptionInput.select();
    this.ui.$descriptionLabel.hide();
  }

  onTitleInputKeydown(e) {
    if (e.keyCode === 13) this.debouncedSetTitle();
  }

  onDescriptionInputKeydown(e) {
    if (e.keyCode === 13) this.debouncedSetDescription();
  }
}

window.HeaderView = HeaderView;
