$ ->
  $('#efi-validate-form').ajaxForm
    target: '#validation-result'
    success: ->
      $('#validation-result-container').show()