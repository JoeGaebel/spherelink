function onPageLoad() {
  fadeAlerts();
  clampDescriptions();
}

function fadeAlerts() {
  setTimeout(function () {
    $('.alert-notice').fadeOut(3000);
  }, 5000);
}

function clampDescriptions() {
  var descriptions = $('.desc');
  for (var i = 0; i < descriptions.length; i++) {
    $clamp(descriptions[i], { clamp: 3 });
  }
}

$(onPageLoad);
