import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['autoAdd', 'repeatable'];

  initialize() {
    if (this.repeatableTarget.value === 'true') {
      console.log('here');
      this.autoAddTarget.style.display = 'block';
    }
  }

  showAutoAdd() {
    this.autoAddTarget.style.display = 'block';
  }

  hideAutoAdd() {
    this.autoAddTarget.style.display = 'none';
  }
}
