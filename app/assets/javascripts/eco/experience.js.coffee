$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')

  $(".flash-fadeout").delay(5000).fadeOut()