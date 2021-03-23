import { Controller } from 'stimulus';
import { Turbo } from '@hotwired/turbo-rails';

export default class extends Controller {
  static targets = ['link', 'button'];

  navigate(event) {
    Turbo.visit(this.linkTarget.href);
  }

  stopPropagation(event) {
    event.stopPropagation();
  }
}
