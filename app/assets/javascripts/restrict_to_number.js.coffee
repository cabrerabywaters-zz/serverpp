window.permiteNumeros = (event) ->
  # Variables que definen los caracteres permitidos
  numeros = "0123456789"
  permitidos = numeros + ".,"
  teclas_especiales = [8, 9, 37, 39, 46]

  # 8 = BackSpace, 46 = Supr, 37 = flecha izquierda, 39 = flecha derecha

  # Obtener la tecla pulsada
  evento = event or window.event
  codigoCaracter = evento.charCode or evento.keyCode
  caracter = String.fromCharCode(codigoCaracter)

  # Comprobar si la tecla pulsada es alguna de las teclas especiales
  # (teclas de borrado y flechas horizontales)
  tecla_especial = false
  for i of teclas_especiales
    if codigoCaracter is teclas_especiales[i]
      tecla_especial = true
      break

  # Comprobar si la tecla pulsada se encuentra en los caracteres permitidos
  # o si es una tecla especial
  permitidos.indexOf(caracter) isnt -1 or tecla_especial
