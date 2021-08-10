import { Controller } from 'stimulus';
import db from 'just-debounce';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.debounce = db((query, path) => this.search(query, path), 200);
  }

  one_off_stories(event) {
    this.debounce(event.target.value, 'one_off_stories');
  }

  repeatable_stories(event) {
    this.debounce(event.target.value, 'repeatable_stories');
  }

  reset(event) {
    const { path } = event.target.dataset;
    this.search(false, path);

    this.inputTarget.value = '';
  }

  async search(query, path) {
    const fullPath = query ? `/${path}?search=${query}` : `/${path}`;

    const response = await fetch(fullPath, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    document.querySelector(`div[data-attributes="${path}"]`).innerHTML =
      await response.text();
  }
}
