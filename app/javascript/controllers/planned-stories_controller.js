import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'doneDivider',
    'productivityBadge',
    'progressBar',
    'plannedStories',
    'completedStories',
    'message',
  ];

  connect() {
    this.completedStoriesObserver = new MutationObserver(
      this.update.bind(this),
    );
    this.completedStoriesObserver.observe(this.completedStoriesTarget, {
      childList: true,
      attributes: false,
      subtree: true,
    });
    this.update();

    this.plannedStoriesObserver = new MutationObserver(this.update.bind(this));
    this.plannedStoriesObserver.observe(this.plannedStoriesTarget, {
      childList: true,
      attributes: false,
      subtree: true,
    });
    this.update();
  }

  disconnect() {
    this.plannedStoriesObserver.disconnect();
    this.completedStoriesObserver.disconnect();
  }

  update() {
    const completedStoryCount = this.completedStoriesTarget.children.length;
    const plannedStoryCount = this.plannedStoriesTarget.children.length;
    const totalCount = completedStoryCount + plannedStoryCount;
    const percentageComplete = (completedStoryCount / totalCount) * 100.0 || 0;
    // Show the divider if there are completed stories
    this.doneDividerTarget.classList.toggle(
      'divider--show',
      completedStoryCount !== 0,
    );

    // Update the productivity badge
    this.productivityBadgeTarget.innerHTML = completedStoryCount;

    // Update the progress bar
    this.progressBarTarget.innerHTML = totalCount - completedStoryCount;
    this.progressBarTarget.setAttribute(
      'aria-valuenow',
      totalCount - completedStoryCount,
    );
    this.progressBarTarget.setAttribute('aria-valuemax', totalCount);
    this.progressBarTarget.style.width = `${100 - percentageComplete}%`;

    // Update the messaging
    if (plannedStoryCount === 0 && completedStoryCount !== 0) {
      this.messageTarget.style.display = 'initial';
      this.messageTarget.innerHTML = window.I18n.all_completed;
    } else if (plannedStoryCount === 0 && completedStoryCount === 0) {
      this.messageTarget.style.display = 'initial';
      this.messageTarget.innerHTML = window.I18n.no_planned_stories_yet;
    } else {
      this.messageTarget.style.display = 'none';
    }
  }
}
