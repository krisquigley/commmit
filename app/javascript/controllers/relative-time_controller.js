import { Controller } from 'stimulus';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
import relativeTime from 'dayjs/plugin/relativeTime';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.extend(relativeTime);
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
export default class extends Controller {
  static targets = ['relativeTime', 'commmit'];

  connect() {
    this.relativeTimeTargets.forEach((target) => {
      const commmit = this.hasCommmitTarget ? 'day' : false;
      const todayOrPast = dayjs().isSameOrAfter(dayjs(target.title), commmit);
      const sameOrBefore = dayjs().isSameOrBefore(dayjs(target.title));

      if (commmit && todayOrPast) {
        target.innerHTML = dayjs(target.title)
          .tz('Europe/London')
          .endOf('day')
          .fromNow();
      } else if (sameOrBefore && !commmit) {
        target.innerHTML = dayjs(target.title).tz('Europe/London').toNow();
      } else {
        target.innerHTML = dayjs(target.title)
          .add(1, commmit)
          .tz('Europe/London')
          .fromNow();
      }
    });
  }
}
