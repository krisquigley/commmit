import { Controller } from 'stimulus';
import db from 'just-debounce';

export default class extends Controller {
  static targets = ['input', 'clear'];

  connect() {
    this.debounce = db((query, path) => this.search(query, path), 200);
  }

  searchStories(event) {
    const { path } = event.target.dataset;
    this.hideShowClearButton();
    this.debounce(event.target.value, path);
  }

  reset(event) {
    const { path } = event.target.dataset;
    this.search(false, path);

    this.inputTarget.value = '';
    this.hideShowClearButton();
    this.inputTarget.focus();
  }

  hideShowClearButton() {
    if (this.inputTarget.value.length > 0) {
      this.clearTarget.style.visibility = 'visible';
    } else {
      this.clearTarget.style.visibility = 'hidden';
    }
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
