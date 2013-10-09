$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')

  $(".flash-fadeout").delay(5000).fadeOut()

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
