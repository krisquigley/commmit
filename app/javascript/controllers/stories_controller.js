import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['autoAdd', 'repeatable', 'autoAddCheckbox'];

  connect() {
    if (this.repeatableTarget.checked) {
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
