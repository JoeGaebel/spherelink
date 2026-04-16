class BaseView {
  constructor() {
    this.viewClass = null;
  }

  hide() {
    $(this.viewClass).hide();
  }

  show() {
    $(this.viewClass).show();
  }
}

window.BaseView = BaseView;
