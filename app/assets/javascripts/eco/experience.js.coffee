$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')

  $(".flash-fadeout").delay(5000).fadeOut()

  # Collapsible sections
  $('.section-header').on 'click', (e) ->
    $(@).closest('.section').find('.section-content').slideToggle()

  # Autosave draft experience
  setInterval ->
    experienceForm = $("form.edit_experience")
    $.ajax
      url: experienceForm.attr("action")
      type: 'POST'
      data: experienceForm.serialize()
      dataType: "JSON"
      success: (json) ->
        console.log json

  , 60000

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
