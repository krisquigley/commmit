import { Controller } from 'stimulus';
import dayjs from 'dayjs';

export default class extends Controller {
  static targets = ['date'];

  today() {
    const today = dayjs().format('YYYY-MM-DD');
    this.dateTarget.value = today;
  }

  tomorrow() {
    const tomorrow = dayjs().add(1, 'day').format('YYYY-MM-DD');
    this.dateTarget.value = tomorrow;
  }
}
