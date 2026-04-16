class ShowMemoryApplication extends MemoryApplication {
  constructor(options = {}) {
    super(options);
    this.sphereSelectView = new SphereSelectView({ app: this, hideCans: true });
  }

  promptForTransition() {
    return true;
  }

  resetPageState() {
    // no-op in show mode
  }
}

window.ShowMemoryApplication = ShowMemoryApplication;
