import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['doneDivider', 'plannedStories', 'doneStories'];

  connect() {
    this.observer = new MutationObserver(this.update.bind(this));
    this.observer.observe(this.doneStoriesTarget, {
      childList: true,
      attributes: false,
      subtree: true,
    });
    this.update();
  }

  disconnect() {
    this.observer.disconnect();
  }

  update() {
    console.log(this.doneDividerTarget, this.doneStoriesTarget.children.length);
    this.doneDividerTarget.classList.toggle(
      'show',
      this.doneStoriesTarget.children.length !== 0,
    );
  }
}
