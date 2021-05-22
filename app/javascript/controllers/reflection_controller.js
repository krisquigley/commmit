import { Controller } from 'stimulus';

export default class extends Controller {
  showReflectionTooltip(event) {
    $('svg[data-toggle="tooltip"]').tooltip('show');
  }
}
