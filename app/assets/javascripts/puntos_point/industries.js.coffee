$ ->
  $("form.industries_percentages input[type='text']").on 'change', (event) ->
    total = 0
    for industry in $("form.industries_percentages input[type='text']")
      total += parseFloat($(industry).val())

    # total = Math.round(total * 10) / 10

    $("form.industries_percentages .percentage_total span.uneditable-input").html(total)

    if total != 100
      $("form.industries_percentages .percentage_total").addClass('error')
      $("form.industries_percentages .percentage_total span.help-inline").removeClass('dn')
    else
      $("form.industries_percentages .percentage_total").removeClass('error')
      $("form.industries_percentages .percentage_total span.help-inline").addClass('dn')