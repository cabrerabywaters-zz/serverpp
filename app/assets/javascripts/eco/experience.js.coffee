$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')

  # Experience validation
  $('form.new_experience, form.edit_experience').validate
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
    $.ajax
      type: 'POST'
      url: form.attr('action')
      data: form.serialize()
      beforeSend: ->
        form.children('.experience-validation').button('loading')

      complete: (data) ->
        form.children('.experience-validation').button('reset')

      success: (data, status) ->
        notice(form, data.type, data.message)

      error: (XMLHttpRequest, status, errorThrown) ->
        notice(form, 'error', 'A ocurrido un error!')

    return false

  # Loading on click: Validation
  # Prepare
  $('.experience-validation').button()

  # Show notice on validation-box
  notice = (form, type, message) ->
    form.append "<div class='alert alert-#{type} flash-fadeout'>#{message}</div>"
    $(".flash-fadeout").delay(5000).fadeOut()