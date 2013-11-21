$ ->
  $('#experience-filter a').click (e) ->
    e.preventDefault()
    $(@).tab('show')
    
  # Formatea un numero y lo devuelve como un string con su respectiva representacion monetaria
  window.numberToCurrency = (number, nDecimalDigits) ->
    parseFloat(number).toFixed(nDecimalDigits)
    # default values
    # decimalSeparator   = ","
    # thousandsSeparator = "."
    # nDecimalDigits     = nDecimalDigits or 0
    # 
    # return if number isnt 0 and not number
    # 
    # number += ''
    # 
    # unformated_number = parseFloat  number#.replace(/[\.]/g, '')
    #                                       #.replace(/[\,]/g,  '.')
    # 
    # fixed = unformated_number.toFixed(nDecimalDigits) #limit/add decimal digits
    # 
    # if nDecimalDigits is 0
    #   parts = RegExp("^(-?\\d{1,3})((\\d{3})+)$").exec(fixed)
    #   if parts
    #     parts[1] + parts[2].replace(/\d{3}/g, thousandsSeparator + "$&")
    #   else
    #     fixed.replace(".", decimalSeparator)
    # else
    #   parts = RegExp("^(-?\\d{1,3})((\\d{3})+)\\.(\\d{" + nDecimalDigits + "})$").exec(fixed)
    #   if parts
    #     parts[1] + parts[2].replace(/\d{3}/g, thousandsSeparator + "$&") + decimalSeparator + parts[4]
    #   else
    #     fixed.replace(".", decimalSeparator)

  # Des-formate un valor monetario y lo devuelve como numero
  window.currencyToNumber = (number) ->
    parseFloat number#.replace(/[\.]/g, '').replace(/[\,]/g,  '.')

  # Callback para formatear un input dado
  window.do_format = (element, precision) ->
    if $(element).val()
      unformated = currencyToNumber $(element).val() || '0'
      unformated = 0 if unformated < 0
      formated   = numberToCurrency(to_string_number(unformated), precision)
      $(element).val(formated)

  # Permite cambiar los separadores decimales y de miles, dado que normalmente se usa '.' para separadores decimales, pero localmente se usa ',', lo cual provoca errors al formatear y des-formatear
  window.to_string_number = (number) ->
    number += ''
    # number = number.replace('.', ',')

  # Funcion que permite construir el valor del descuento porcentual, en base a al precio y el precio con descuento
  make_discount_percentage = () ->
    unformated_price            = currencyToNumber $('input#experience_amount').val()           || '0'
    unformated_discounted_price = currencyToNumber $('input#experience_discounted_price').val() || '0'

    price            = parseInt(unformated_price)
    discounted_price = parseInt(unformated_discounted_price)
    discount         = 100 - (parseFloat(discounted_price * 100 / price) || 0)

    # discount          = 0   if discount < 0
    # discount          = 100 if discount > 100

    formated_price            = numberToCurrency(price,                      0)
    formated_discounted_price = numberToCurrency(discounted_price,           0)
    formated_discount         = numberToCurrency(to_string_number(discount), 2)

    $('input#experience_amount').val(formated_price)
    $('input#experience_discounted_price').val(formated_discounted_price)
    $('input#experience_discount_percentage').val(formated_discount)

  # Funcion que permite construir el valor del precio, en base a al precio con descuento y descuento porcentual
  make_price = () ->
    unformated_discounted_price = currencyToNumber $('input#experience_discounted_price').val()    || '0'
    unformated_discount         = currencyToNumber $('input#experience_discount_percentage').val() || '0'

    # console.log unformated_discount

    discounted_price = parseInt(unformated_discounted_price)
    discount         = parseFloat(unformated_discount)
    price            = parseInt((100 * discounted_price) / (100 - discount))

    # discount          = 0   if discount < 0
    # discount          = 100 if discount > 100

    formated_price            = numberToCurrency(price,                      0)
    formated_discounted_price = numberToCurrency(discounted_price,           0)
    formated_discount         = numberToCurrency(to_string_number(discount), 2)

    $('input#experience_amount').val(formated_price)
    $('input#experience_discounted_price').val(formated_discounted_price)
    $('input#experience_discount_percentage').val(formated_discount)

  # Funcion que permite construir el valor del precio con descuento, en base a al precio y descuento porcentual
  make_discounted_price = () ->
    unformated_price    = currencyToNumber($('input#experience_amount').val()              || 0)
    unformated_discount = currencyToNumber($('input#experience_discount_percentage').val() || 0)

    unformated_discount = 0   if unformated_discount < 0
    unformated_discount = 100 if unformated_discount > 100

    price            = parseInt(unformated_price)
    discount         = parseFloat(unformated_discount)
    discounted_price = parseInt(((price * (100 - discount)) / 100) || 0)

    formated_price            = numberToCurrency(price,                      0)
    formated_discounted_price = numberToCurrency(discounted_price,           0)
    formated_discount         = numberToCurrency(to_string_number(discount), 2)

    $('input#experience_amount').val(formated_price)
    $('input#experience_discounted_price').val(formated_discounted_price)
    $('input#experience_discount_percentage').val(formated_discount)

  $('input#experience_discounted_price').on 'change', (event) ->
    do_format $(this), 0

    if $('input#experience_discounted_price').val() and $('input#experience_amount').val()
      make_discount_percentage()

    else if $('input#experience_discounted_price').val() and $('input#experience_discount_percentage').val()
      make_price()

    else
      $('input#experience_discount_percentage').val('')

  $('input#experience_discount_percentage').on 'change', (event) ->
    do_format $(this), 2

    if $('input#experience_discount_percentage').val() and $('input#experience_amount').val()
      make_discounted_price()

    else if $('input#experience_discount_percentage').val() and $('input#experience_discounted_price').val()
      make_price()

    else if $('input#experience_discounted_price').val() and $('input#experience_amount').val()
      $('input#experience_discounted_price').trigger 'change'

  $('input#experience_amount').on 'change', (event) ->
    do_format $(this), 0

    if $('input#experience_discount_percentage').val() and $('input#experience_amount').val()
      make_discounted_price()

    else if $('input#experience_discounted_price').val() and $('input#experience_amount').val()
      make_discount_percentage()

  $('input#experience_discounted_price').trigger 'change'
