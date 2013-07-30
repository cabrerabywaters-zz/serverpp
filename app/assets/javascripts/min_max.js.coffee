# Permite callback's para limitar el contenido de un campo de numero.
#
# Opciones:
#    data-min:    indica el valor minimo permitido.
#    data-max:    indica el valor máximo permitido.
#    data-blank:  indica que el input permite valores vacios.
#
# Markup:
#    <input data-min='0' data-max='100' data-blank='true'>
#
$ ->
  $(document).on 'change', 'input.min_max', (event) ->
    val = $(this).val()

    unless (val is undefined or val is "") and $(this).data('blank')
      min = $(this).data('min')
      max = $(this).data('max')

      if min != undefined
        $(this).val(min) if val < min

      if max != undefined
        $(this).val(max) if val > max