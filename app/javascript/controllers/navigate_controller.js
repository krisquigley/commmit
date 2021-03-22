import { Controller } from 'stimulus';
import { Turbo } from '@hotwired/turbo-rails';

export default class extends Controller {
  static targets = ['link'];

  navigate() {
    Turbo.visit(this.linkTarget.href);
  }
}
