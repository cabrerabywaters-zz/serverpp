jQuery.validator.setDefaults
  errorPlacement: (error, element) ->
    console.log 'Placing error'
    # if the input has a prepend or append element, put the validation msg after the parent div
    if element.parent().hasClass("input-prepend") or element.parent().hasClass("input-append")
      error.insertAfter element.parent()

    # else just place the validation message immediatly after the input
    else
      error.insertAfter element

  errorElement: "span" # contain the error msg in a small tag
  errorClass: 'help-inline'
  # wrapper: "div" # wrap the error message and small tag in a div
  highlight: (element) ->
    console.log 'highlight'
    $(element).closest(".control-group").addClass "error" # add the Bootstrap error class to the control group

  success: (element) ->
    console.log 'success'
    $(element).closest(".control-group").removeClass "error" # remove the Boostrap error class from the control group
