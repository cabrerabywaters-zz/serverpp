# encoding: utf-8

# Public: Clase para manejar la integración con las diferentes EFI's.
#
# @public BaseConnector initialize(attributes) Constructor de la clase.
#
# @public Integer get_points() Permite consultar la cantidad de puntos asociados al rut dado.
#
# @public Boolean spend_points() Permite consumir una cierta cantidad de puntos.
#
# @private EFI efi() Entrega la EFI con la que se esta conectando.
#
class BaseConnector
  # Providing the functionality that ActiveModel::Naming provides in your object is required to pass the Active Model Lint test. So either extending the provided method below, or rolling your own is required.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Naming.html
  extend ActiveModel::Naming
  # This also provides the required class methods for hooking into the Rails internationalization API, including being able to define a class based i18n_scope and lookup_ancestors to find translations in parent classes.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Translation.html
  extend ActiveModel::Translation
  # Handles default conversions: #to_model, #to_key, #to_param, and to_partial_path.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Conversion.html
  include ActiveModel::Conversion
  # Permite usar el sistema de rutas de Rails, que normalmente es accesible solo en vistas y controladores.
  include Rails.application.routes.url_helpers

  # identifier_name:  Nombre del valor extra requerido para la integración.
  #                   EJ: número de teléfono, correo electrónico, etc.
  # identifier_value: Valor extra requerido para la integración.
  # points:           Puntos que se van a descontar.
  # Mas información en: http://www.rubyist.net/~slagell/ruby/accessors.html
  attr_accessor :efi_id,
                :rut,
                :password,
                :points,
                :identifier_value,
                :identifier_name

  # Internal: Constructor de la clase.
  #           Entrega una instancia de la clase BaseConnector
  #           para realizar alguna consulta a sobre los puntos
  #           de una cuenta de la EFI.
  #
  #
  # @parametros:
  # Hash attributes - Los datos necesario para iniciar la conexión.
  #
  # Ejemplo
  #
  #   BaseConnector.new {efi_id: 1, rut: '12.345.678-5', ...}
  #   # => #<BaseConnector:0x007f9b41242a28 @efi_id="1", @rut="12.345.678-5", ...>
  #
  # Retorna una instancia de BaseConnector
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # Le indica al ORM de Rails que este modelo no tiene asociada
  # una tabla en la Base de Datos
  def persisted?
    false
  end

  # Internal: Permite consultar la cantidad de puntos asociados al rut dado.
  #
  # Ejemplo
  #   a) Para una cuenta sin puntos
  #     get_points()
  #     # => '0'
  #
  #
  #   b) Para una cuenta con 100 puntos
  #     get_points()
  #       # => '100'
  #
  #   c) Para un rut que no registrado por la EFI
  #     get_points()
  #       # => nil
  #
  # Retorna un Integer con la cantidad final de puntos en la cuenta.
  def get_points
    # Quito el formato del rut dado.
    # Ejemplo
    #  Run.remove_format('12.345.678-5')
    #  # => '123456785'
    rut_without_format = Run.remove_format(self.rut)

    # Busco la cuenta del usuario por el RUT en la base de datos de la EFI
    # y se la asigno a la variable account.
    account = efi.accounts.find_by_rut(rut_without_format)

    if account
      # Si se encontro una cuenta, se retorna la cantidad de puntos de la misma.
      account.points
    else
      # Si no se encontro una cuenta se retorna nil,
      # para indicar que la cuenta no existe.
      nil
    end
  end

  # Internal: Permite consumir una cierta cantidad de puntos.
  #
  # Ejemplo
  #   a) Para una cuenta sin puntos
  #     spend_points()
  #     # => false
  #
  #
  #   b) Para una cuenta con 100 puntos, consumir 50
  #     spend_points()
  #       # => true
  #
  #
  #   c) Para una cuenta con 100 puntos, consumir 200
  #     spend_points()
  #       # => false
  #
  #   d) Para un rut que no registrado por la EFI
  #     spend_points()
  #       # => nil
  #
  # Retorna un Integer con la cantidad final de puntos en la cuenta.
  def spend_points
    # Quito el formato del rut dado.
    # Ejemplo
    #   Run.remove_format('12.345.678-5')
    #   # => '123456785'
    rut_without_format = Run.remove_format(self.rut)

    # Busco la cuenta del usuario por el RUT y Contraseña en la base de datos de la EFI
    # y se la asigno a la variable account.
    account = efi.accounts.find_by_rut_and_password(rut_without_format, self.password)

    if account
      # Si se encontro una cuenta,
      # se construye una transaccion para descontar los puntos de la misma.
      transaction = account.transactions.build(points: self.points, operation_id: Operation.expend_id)

      if transaction.save
        # Si los puntos en la cuenta son suficientes,
        # se indica que descontaron los puntos.
        return true
      else
        # Si los puntos en la cuenta son insuficientes,
        # se indica que no se pueden descontar los puntos.
        return false
      end
    else
      # Si no se encontro una cuenta se retorna nil,
      # para indicar que la cuenta no existe.
      return nil
    end
  end

  private
  # Internal: Entrega la EFI con la que se esta conectando.
  #
  # Ejemplo
  #   efi()
  #   # => #<Efi id: 1, rut: "111111111", name: "Test", ...>
  #
  # Retorna una instancia de EFI.
  def efi
    Efi.find(self.efi_id)
  end

  # Internal: Entrega la URL del catalogo (mini-paágina) de la EFI.
  #
  # Ejemplo
  #   a) Para una EFI Dominio corporativo: "test"
  #   base_url()
  #   # => 'http://puntospoint.com/test'
  #
  # NOTA: Esto es asumiendo que estamos en producción y que ya se esta usando el
  #       dominio puntospoint.com y no la IP de QA
  #
  # Retorna una instancia de EFI.
  def base_url
    # corporative_root_url: es un helper de ruta de Rails.
    corporative_root_url(self.efi_id)
  end
end