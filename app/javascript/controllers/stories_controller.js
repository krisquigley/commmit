import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['autoAdd', 'repeatable', 'autoAddCheckbox'];

  initialize() {
    if (this.repeatableTarget.selected) {
      this.autoAddTarget.style.display = 'block';
    }
  }

  showAutoAdd() {
    this.autoAddTarget.style.display = 'block';
  }

  hideAutoAdd() {
    this.autoAddCheckboxTarget.checked = false;
    this.autoAddTarget.style.display = 'none';
  }
}
