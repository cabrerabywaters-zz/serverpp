# encoding: utf-8

# Public: Clase para manejar helperes de vista para todas las vista de la aplicación.
#
module ApplicationHelper
  # Internal: Entrega una representacion iconica de una variable booleana.
  #           Esto implica que para un valor dado, se genera la estructura html
  #           que permite mostrarlo en forma de check's, utilizando para esto
  #           las clases por defecto de Bootstrap. (http://twitter.github.io/bootstrap/base-css.html#icons)
  #
  # @parametros:
  # Boolean value - el valor a representar
  #
  # Ejemplo
  #
  #   a) booleanize true
  #      # => '<i class='icon-ok'></i>'
  #
  #   b) booleanize false
  #      # => '<br/>'
  #
  # Retorna un String.
  def booleanize value
    value ? raw("<i class='icon-ok'></i>") : raw('<br/>')
  end

  # Internal: Entrega un texto dado con un máximo de caracteres. Si el texto
  #           tiene un largo mayor a lo especificado, se corta y se agregan
  #           puntos suspensivos (...).
  #
  # @parametros:
  # String  to_trim    - el valor a representar
  # Integer characters - numero máximo de caracteres
  #
  # Ejemplo
  #
  #   a) trim_to 'texto super largo', 10
  #      # => <span class="as_tooltip" data-toggle="tooltip" title="texto super largo" data-placement="bottom">texto supe....</span>
  #
  #   b) trim_to 'texto no tan largo', 20
  #      # => <span class="as_tooltip" data-toggle="tooltip" title="texto no tan largo" data-placement="bottom">texto no tan largo</span>
  #
  # Retorna un String.
  def trim_to to_trim, characters=20
    to_trim = '' if to_trim.nil?

    if to_trim.length > characters
      '<span class="as_tooltip" data-toggle="tooltip" title="' + to_trim + '" data-placement="bottom">' + to_trim[0..characters] + '...</span>'
    else
      '<span class="as_tooltip" data-toggle="tooltip" title="' + to_trim + '" data-placement="bottom">' + to_trim + '</span>'
    end
  end
end
