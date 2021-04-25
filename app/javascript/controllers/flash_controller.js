import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  connect() {
    // Autodismiss alerts
    $('div[role="alert"]')
      .fadeTo(1500, 500)
      .slideUp(500, function () {
        $('div[role="alert"]').remove();
      });
  }
}
