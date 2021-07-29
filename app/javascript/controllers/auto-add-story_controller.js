import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['autoAdd', 'repeatable', 'autoAddRadio'];

  connect() {
    if (this.repeatableTarget.checked) {
      this.autoAddTarget.style.display = 'block';
    }
  }

  showAutoAdd() {
    this.autoAddTarget.style.display = 'block';
  }

  hideAutoAdd() {
    this.autoAddRadioTarget.checked = false;
    this.autoAddTarget.style.display = 'none';
  }
}
