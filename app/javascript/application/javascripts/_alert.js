import $ from 'jquery';

document.addEventListener('turbo:load', function () {
  // Autodismiss alerts
  $('div[role="alert"]')
    .fadeTo(1500, 500)
    .slideUp(500, function () {
      $('div[role="alert"]').slideUp(500);
    });
});
