# Encargado de cambiar la presentacion de las experiencias al pasar por encima.
#
$ ->
  $(".experience_info").hover (event) ->
    $(".experience_info").removeClass 'dn'
    $(".experience_more").addClass 'dn'

    $(this).addClass "dn"
    $(this).prev('.experience_more').removeClass 'dn'

  $(".experience_more").mouseleave (event) ->
    $(".experience_more").addClass "dn"
    $(".experience_info").removeClass 'dn'
