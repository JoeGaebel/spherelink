class SphereSelectView {
  constructor(options = {}) {
    this.app = options.app;
    this.portalView = options.portalView;
    this.hideCans = options.hideCans;
    $(document).ready(this.onDocumentReady.bind(this));
  }

  onDocumentReady() {
    this.renderSpheres();
  }

  renderSpheres() {
    for (const sphere of window.memory.spheres) {
      const $addSphereLink = $('.add-sphere-link');
      const $loading = $('.sphere-item-view.spinner');

      const $injectBeforeElement = $loading.length ? $($loading[0]) : $addSphereLink;

      if ($(`#sphere-${sphere.id}`).length === 0) {
        const view = new SphereView(_.extend({}, sphere, { hideCan: this.hideCans }));
        const html = view.render();

        if ($injectBeforeElement.length) {
          $(html).insertBefore($injectBeforeElement);
        } else {
          $('.sphere-select-view').append(html);
        }

        $(`#${sphere.id}.sphere-link`).click(this.onSphereLinkClick.bind(this));
        $(`#${sphere.id}.delete-sphere`).click(this.onSphereDeleteClick.bind(this));
      }
    }
  }

  async deleteSphere(sphereId) {
    try {
      const sphere = await window.spherelinkAPI.deleteSphere(sphereId);
      this.onSphereDeleteSuccess({ id: sphereId });
    } catch (e) {
      this.app.onAjaxError(e);
    }
  }

  cleanSphereCache(sphereId) {
    const cachedSphere = _.findWhere(window.memory.spheres, { id: sphereId });
    const indexOfCachedSphere = window.memory.spheres.indexOf(cachedSphere);
    if (indexOfCachedSphere !== -1) {
      memory.spheres.splice(indexOfCachedSphere, 1);
    }
  }

  removeAssociatedPortals(sphereId) {
    let portals = _.pluck(memory.spheres, 'portals');
    portals = _.flatten(portals);
    const portalsToClean = _.where(portals, { to_sphere_id: sphereId });

    for (const portal of portalsToClean) {
      const sphere = _.findWhere(memory.spheres, { id: portal.from_sphere_id });
      const index = sphere.portals.indexOf(portal);
      sphere.portals.splice(index, 1);

      if (currentSphere.id === portal.from_sphere_id) {
        window.PSV.removeMarker(portal.id);
      }
    }
  }

  onSphereLinkClick(e) {
    if (!this.app.promptForTransition()) return;

    const id = parseInt(e.currentTarget.id);
    const associatedSphere = _.findWhere(window.memory.spheres, { id });
    this.app.setNextSphere(associatedSphere);
    this.app.resetPageState();
  }

  onSphereDeleteClick(e) {
    const id = parseInt(e.currentTarget.id);
    const response = confirm("Delete this sphere and it's associated markers and portals?");
    if (response) {
      this.deleteSphere(id);
    }
  }

  onSphereDeleteSuccess(sphere) {
    this.cleanSphereCache(sphere.id);
    this.removeAssociatedPortals(sphere.id);
    this.app.portalView.updateSelect();

    if (currentSphere.id === sphere.id) {
      if (memory.spheres.length) {
        this.app.resetPageState();
        this.app.setNextSphere(memory.spheres[0]);
      } else {
        delete window.currentSphere;
        this.app.handleEmptyPage();
      }
    }

    $(`.add-sphere-view #sphere-${sphere.id}`).remove();
  }
}

window.SphereSelectView = SphereSelectView;
