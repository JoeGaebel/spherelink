class SpinnerView {
  constructor(id, className) {
    this.id = id;
    this.className = className;
  }

  template() {
    return `
      <div id="spinner-${this.id}" class="${this.className} spinner">
        <img src="./images/spinner.svg">
        <div class="status-text">Uploading...</div>
      </div>
    `;
  }

  render() {
    return this.template();
  }

  showProgress(id) {
    $(`#spinner-${id} .status-text`).text('Processing...');
  }

  hideProgress(id) {
    $(`#spinner-${id} .status-text`).hide();
  }
}

window.SpinnerView = SpinnerView;
