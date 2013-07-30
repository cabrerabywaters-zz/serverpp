# Encargado de mostrar las forma de canje a la hora de elegir exclusividad.
#
$ ->
  $('input[name="event[exclusivity_id]"]').on 'click', (event) ->
    if $(this).hasClass('exchange')
      $('.event_form .swaps_field').removeClass('dn')
      $('.event_form .quantity_field').addClass('dn')
    else
      $('.event_form .swaps_field').addClass('dn')
      $('.event_form .quantity_field').removeClass('dn')

    $('.event_form').removeClass('dn')

    $('span.input-large.uneditable-input').html $(this).data('quantity')

    # Muevo el scroll hasta abajo
    window.scrollTo(0, document.body.scrollHeight)