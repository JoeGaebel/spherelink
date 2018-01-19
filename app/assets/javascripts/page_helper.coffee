onPageLoad = ->
  fadeAlerts()
  clampDescriptions()

fadeAlerts = ->
  $(".alert-notice").fadeOut(3000)

clampDescriptions = ->
  descriptions = $('.desc')
  for description in descriptions
    $clamp(description, { clamp: 3 });

$(onPageLoad)


