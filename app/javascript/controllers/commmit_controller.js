import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  static targets = [
    'goalId',
    'commmitGoal',
    'chooseButton',
    'chosenCommmitGoalId',
  ];

  async connect() {
    if (this.hasGoalIdTarget && this.goalIdTarget.value)
      this.fetchCommmitGoal(this.goalIdTarget.value);

    this.commmitGoalObserver = new MutationObserver(
      this.updateGoalId.bind(this),
    );
    this.commmitGoalObserver.observe(this.commmitGoalTarget, {
      childList: true,
      attributes: true,
      subtree: true,
    });
    this.updateGoalId();
  }

  disconnect() {
    this.commmitGoalObserver.disconnect();
  }

  updateGoalId() {
    if (this.hasChosenCommmitGoalIdTarget) {
      $('#chooseGoalModal').modal('hide');
      this.chooseButtonTarget.hidden = true;
      this.goalIdTarget.value = this.chosenCommmitGoalIdTarget.id;
    }
  }

  async chooseGoal(event) {
    this.fetchCommmitGoal(event.target.id);
  }

  async fetchCommmitGoal(id) {
    const response = await fetch(`/commmit_goal/${id}`, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    if (response.status === 200) {
      this.commmitGoalTarget.innerHTML = await response.text();
    }
  }
}
