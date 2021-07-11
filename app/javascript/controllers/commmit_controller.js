import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  static targets = ['goalId', 'commmitGoal'];

  async chooseGoal(event) {
    this.goalIdTarget.value = event.target.id;
    $('#chooseGoalModal').modal('hide');

    const response = await fetch(`/commmit_goal/${event.target.id}`, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    this.commmitGoalTarget.innerHTML = await response.text();
  }
}
