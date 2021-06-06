import { Controller } from 'stimulus';
import TinyGesture from 'tinygesture';
import $ from 'jquery';

export default class extends Controller {
  connect() {
    const target = document.getElementById('tabContent');
    const gesture = new TinyGesture(target);
    const noOfTabs =
      document.querySelector('ul[role="tablist"]').children.length;

    gesture.on('swiperight', (event) => {
      const currentSelectedTab = this._getCurrentTabId();

      if (currentSelectedTab > 1) {
        $(`#${currentSelectedTab - 1}`).tab('show');
      }
    });

    gesture.on('swipeleft', (event) => {
      const currentSelectedTab = this._getCurrentTabId();

      if (currentSelectedTab < noOfTabs) {
        $(`#${currentSelectedTab + 1}`).tab('show');
      }
    });
  }

  _getCurrentTabId() {
    return Number(document.querySelector('a[aria-selected="true"]').id);
  }
}
