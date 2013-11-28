# Encargado de cambiar la presentacion de las experiencias al pasar por encima.
#
$ ->
  $(".experience_info").hover (event) ->

#Muestra la imagen para todas las experiencias  
    $(".experience_info").removeClass 'dn'
   
#Esconde ell cuadro gris para todas las experiencias
    $(".experience_more").addClass 'dn'

   
# Esconde la foto para la experiencia seleccionada
   # $(this).addClass "dn"


 # Muestra el cuadro gris para la experiencia seleccionada   
   # $(this).prev('.experience_more').removeClass 'dn'

 
#Cuando el mouse deja de estar sobre el cuadro gris
 $(".experience_more").mouseleave (event) ->
   
#Esconde el cuadro gris
    $(".experience_more").addClass "dn"
    
#Muestra el cuadro con la foto
    $(".experience_info").removeClass 'dn'
