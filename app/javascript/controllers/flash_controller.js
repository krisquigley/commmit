import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  connect() {
    // Autodismiss alerts
    const flash = $('div[role="alert"]');

    flash.fadeTo(1500, 500).slideUp(500, function () {
      flash.remove();
    });
  }
}
