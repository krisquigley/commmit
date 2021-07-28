import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  static targets = ['storyForm', 'resetForm'];

  async editStory(event) {
    event.preventDefault();

    await this.fetchStory(
      event.target.closest('div[data-name="storyCard"]').id,
    );
    $('#newStoryModal').modal('show');
  }

  async fetchStory(id) {
    const response = await fetch(`/stories/${id}/edit`, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    if (response.status === 200) {
      this.storyFormTarget.innerHTML = await response.text();
    }
  }

  async fetchNewStory() {
    const response = await fetch(`/stories/new`, {
      headers: {
        'Turbo-Frame': 'true',
      },
    });

    if (response.status === 200) {
      this.storyFormTarget.innerHTML = await response.text();
    }
  }

  closeModal() {
    $('#newStoryModal').modal('hide');
  }

  async resetForm() {
    await this.fetchNewStory();
  }
}
