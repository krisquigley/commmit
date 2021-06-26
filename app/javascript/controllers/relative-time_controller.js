import { Controller } from 'stimulus';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
import relativeTime from 'dayjs/plugin/relativeTime';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.extend(relativeTime);
dayjs.extend(isSameOrBefore);

export default class extends Controller {
  static targets = ['relativeTime', 'commmit'];

  connect() {
    this.relativeTimeTargets.forEach((target) => {
      const commmit = this.hasCommmitTarget ? 'day' : false;
      const today = dayjs().isSame(dayjs(target.title), commmit);
      const past = dayjs().isAfter(dayjs(target.title), commmit);

      if (today) {
        target.innerHTML = dayjs(target.title).tz('Europe/London').toNow();
      } else if (past) {
        target.innerHTML = dayjs(target.title).tz('Europe/London').fromNow();
      } else {
        target.innerHTML = dayjs(target.title)
          .add(1, commmit)
          .tz('Europe/London')
          .fromNow();
      }
    });
  }
}
