$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')

  # Experience validation
  $('form.edit_experience').validate
    onfocusout: (element) ->
      @element(element)
    rules:
      "experience[swaps]":
        number: true
        min: 1
      "experience[amount]":
        number: true
        min: 1
      "experience[discounted_price]":
        number: true
        min: 1
      "experience[discount_percentage]":
        number: true
        min: 0
        max: 100
      "experience[codes_by_purchase]":
        number: true
        min: 1

  # Code validation
  $('.validation-box form').submit ->
    form = $(this)
    $.post(
      $(this).attr('action')
      $(this).serialize()
      (data, textStatus, jqXHR) ->
        form.append "<div class='alert alert-#{data.type} flash-fadeout'>#{data.message}</div>"
        form.children('.experience-validation').button('reset')
        $(".flash-fadeout").delay(5000).fadeOut()
    )
    return false

  # Loading on click: Validation
  # Prepare
  $('.experience-validation').button()
  # Loading...
  $('.experience-validation').click (e) ->
    $(@).button('loading')