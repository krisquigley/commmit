import { Controller } from 'stimulus';
import db from 'just-debounce';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.debounce = db((query, path) => this.search(query, path), 200);
  }

  searchStories(event) {
    const { path } = event.target.dataset;
    this.debounce(event.target.value, path);
  }

  reset(event) {
    const { path } = event.target.dataset;
    this.search(false, path);

    this.inputTarget.value = '';
  }

  async search(query, path) {
    const fullPath = query ? `${path}?search=${query}` : path;

    const response = await fetch(fullPath, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });
    const responseContent = await response.text();

    const storiesContainer = document.querySelector(
      `div[data-attributes="${path}"]`,
    );

    if (response.status === 200) {
      storiesContainer.innerHTML = responseContent;
    }
  }
}
