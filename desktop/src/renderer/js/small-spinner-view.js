class SmallSpinnerView {
  template() {
    return `
      <div class="small-spinner">
        <img src="./images/small-spinner.gif">
      </div>
    `;
  }

  render() {
    return this.template();
  }
}

window.SmallSpinnerView = SmallSpinnerView;
