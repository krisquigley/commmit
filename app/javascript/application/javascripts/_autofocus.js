document.addEventListener('turbo:load', function () {
  // Solution to fix autofocus when turbo has cached the page
  if (document.querySelector('input[autofocus]')) {
    document.querySelector('input[autofocus]').focus();
  }
});
