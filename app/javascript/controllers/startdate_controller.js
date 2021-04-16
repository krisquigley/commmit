import { Controller } from 'stimulus';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
dayjs.extend(utc);
dayjs.extend(timezone);

export default class extends Controller {
  static targets = ['date'];

  today() {
    const today = dayjs().tz('Europe/London').format('YYYY-MM-DD');
    this.dateTarget.value = today;
  }

  tomorrow() {
    const tomorrow = dayjs()
      .tz('Europe/London')
      .add(1, 'day')
      .format('YYYY-MM-DD');
    this.dateTarget.value = tomorrow;
  }
}
