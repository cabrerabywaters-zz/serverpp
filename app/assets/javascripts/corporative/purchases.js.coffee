$ ->
  # Para que al cambiar de forma de canje se actualice la vista de canjear una experiencia.
  $('input[name="purchase[exchange_id]"]').on 'change', (event) ->
    $('h6.discount span').html $(this).next('span.payment_method_datails').find('span.points').html()

  # Gatilla el comportamiento de la funcion anterior, solo en caso de que el input este presente
  if $('input[name="purchase[exchange_id]"]:checked').length == 0
    $('input[name="purchase[exchange_id]"]:first').trigger('click')