onPageLoad = ->
  fadeAlerts()
  clampDescriptions()

fadeAlerts = ->
  setTimeout((-> $(".alert-notice").fadeOut(3000)), 5000)

clampDescriptions = ->
  descriptions = $('.desc')
  for description in descriptions
    $clamp(description, { clamp: 3 });

$(onPageLoad)


