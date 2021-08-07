import { Controller } from 'stimulus';
import db from 'just-debounce';

export default class extends Controller {
  connect() {
    this.debounce = db((query) => this._search(query), 200);
  }

  stories(event) {
    this.debounce(event.target.value);
  }

  async _search(query) {
    const response = await fetch(`/one_off_stories?search=${query}`, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    document.querySelector('div[data-attributes="one_off_stories"]').innerHTML =
      await response.text();
  }
}
