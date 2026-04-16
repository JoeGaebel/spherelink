class SphereView {
  constructor(options = {}) {
    this.id = options.id;
    this.thumb = options.thumb;
    this.caption = options.caption;
    this.hideCan = options.hideCan;
  }

  render() {
    return this.template();
  }

  template() {
    const hiddenClass = this.hideCan ? 'hidden' : '';
    return `
      <div id="sphere-${this.id}" class="sphere-item-view">
        <div id="${this.id}" class="glyphicon glyphicon-trash delete-sphere delete-shadow ${hiddenClass}"></div>
        <div id="${this.id}" class="glyphicon glyphicon-trash delete-sphere ${hiddenClass}"></div>
        <a href="javascript:;" id="${this.id}" class="sphere-link">
          <img src="${this.thumb}">
        </a>
        <div class="caption">${_.escape(this.caption)}</div>
      </div>
    `;
  }
}

window.SphereView = SphereView;
