# Se encarga previsualizar una imagen que fue seleccionada por el usuario,
# pero que aun no es subida al servidor.
#
$ ->
  $('.preview_image').on 'change', (event) ->
    el = (if (event.target) then event.target else event.srcElement)

    if el.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(".preview_container").attr("src", e.target.result).width(470).height(350)

      reader.readAsDataURL el.files[0]