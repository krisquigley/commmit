import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['autoAdd'];

  showAutoAdd() {
    this.autoAddTarget.style.display = 'block';
  }

  hideAutoAdd() {
    this.autoAddTarget.style.display = 'none';
  }
}
