# Oculta/Muestra div para indicar que una efi fue seleccionada para poder
# participar en la experiencia.
$ ->
  $('.checkboxEfis label input.check_boxes').on 'change', (event) ->
    if $(this).is(':checked')
      $(this).parent().find('.hoverEfis').removeClass('dn')
    else
      $(this).parent().find('.hoverEfis').addClass('dn')
