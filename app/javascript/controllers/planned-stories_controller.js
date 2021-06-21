import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'doneDivider',
    'progressBarLeft',
    'progressBarDone',
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

    // Update the progress bar with goals left
    this.progressBarLeftTarget.innerHTML = totalCount - completedStoryCount;
    this.progressBarLeftTarget.setAttribute(
      'aria-valuenow',
      totalCount - completedStoryCount,
    );
    this.progressBarLeftTarget.setAttribute('aria-valuemax', totalCount);
    this.progressBarLeftTarget.style.width = `${100 - percentageComplete}%`;

    // Update the progress bar with goals done
    this.progressBarDoneTarget.innerHTML = completedStoryCount;
    this.progressBarDoneTarget.setAttribute(
      'aria-valuenow',
      completedStoryCount,
    );
    this.progressBarDoneTarget.setAttribute('aria-valuemax', totalCount);
    this.progressBarDoneTarget.style.width = `${percentageComplete}%`;

    // Update the messaging
    if (
      plannedStoryCount === 0 &&
      completedStoryCount !== 0 &&
      window.I18n.all_completed
    ) {
      this.messageTarget.style.display = 'initial';
      this.messageTarget.innerHTML = window.I18n.all_completed;
    } else if (
      plannedStoryCount === 0 &&
      completedStoryCount === 0 &&
      window.I18n.no_planned_stories_yet
    ) {
      this.messageTarget.style.display = 'initial';
      this.messageTarget.innerHTML = window.I18n.no_planned_stories_yet;
    } else {
      this.messageTarget.style.display = 'none';
    }
  }
}
