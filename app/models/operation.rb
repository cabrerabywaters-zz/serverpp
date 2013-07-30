# encoding: utf-8

# Public: Clase estática que permite mantener desacoplado el funcionamiento de
#         las operaciones sobre las cuentas de puntos de los usuarios de las EFI's.
#
# @public Operation initialize(attributes) Constructor de la clase.
#
# @public Array ids() Función de Clase. Permite obtener todos los ids disponibles.
#
# @public Operation find() Función de Clase. Permite buscar una operación.
#
# @private Array all() Función de Clase. Entrega un arreglo con los datos de las operaciones.
#
# @private Integer expend_id() Función de Clase. Entrega el id de la operación
#                              que permite que el usuario consuma/gaste sus puntos.
#
class Operation
  # Providing the functionality that ActiveModel::Naming provides in your object is required to pass the Active Model Lint test. So either extending the provided method below, or rolling your own is required.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Naming.html
  extend ActiveModel::Naming
  # This also provides the required class methods for hooking into the Rails internationalization API, including being able to define a class based i18n_scope and lookup_ancestors to find translations in parent classes.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Translation.html
  extend ActiveModel::Translation
  # Handles default conversions: #to_model, #to_key, #to_param, and to_partial_path.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Conversion.html
  include ActiveModel::Conversion

  # mechanism: Operación matemática que aplica.
  # Mas información en: http://www.rubyist.net/~slagell/ruby/accessors.html
  attr_accessor :id,
                :name,
                :mechanism

  # Internal: Constructor de la clase.
  #           Entrega una instancia de la clase Operation.
  #
  #
  # @parametros:
  # Hash attributes - Los datos de la operación misma estos deben contener
  #                   :id, :name y :mechanism.
  #
  # Ejemplo
  #
  #   Operation.new {id: 1, name: 'Ajuste de Punt', mechanism: '='}
  #   # => #<Operation:0x007f9b41242a28 @id="1", @name="Ajuste de Punt", @mechanism="=">
  #
  # Retorna una instancia de Operation
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

  # HASH con la definición estática de las diferentes operaciones disponibles
  OPERATIONS = [{id: 1, name: 'Ajuste de Punto',      mechanism: '=' },
                {id: 2, name: 'Cargar Puntos',        mechanism: '+' },
                {id: 3, name: 'Quitar Puntos',        mechanism: '-' },
                {id: 4, name: 'Devolución de Puntos', mechanism: '+' },
                {id: 5, name: 'Consumir Puntos',      mechanism: '-' }]

  # Internal: Función de Clase. Permite obtener todos los ids disponibles.
  #
  # Ejemplo
  #
  #   Operation.ids
  #   # => [1, 2, 3, 4, 5]
  #
  # Retorna un Array con los ids disponibles.
  def self.ids
    OPERATIONS.map{ |i| i[:id] }
  end

  # Internal: Función de Clase. Permite buscar una operación.
  #
  # Ejemplo
  #
  #   Operation.find(1)
  #   # => #<Operation:0x007f9b41242a28 @id="1", @name="Ajuste de Punt", @mechanism="=">
  #
  # Retorna un Array con los ids disponibles.
  def self.find id
    if ids.include? id
      Operation.new OPERATIONS[id-1]
    end
  end

  # Internal: Función de Clase. Entrega un arreglo con los datos de las operaciones.
  #           No precisamente un arreglo con instancias de Operaciones, sino que
  #           un arreglo con los nombres de las operaciones y sus respectivos id's,
  #           esto es usado como parámetro en los formularios, al momento de la
  #           creación de una transacción.
  #
  # Ejemplo
  #
  #   Operation.all
  #   # => [["Ajuste de Punto", 1], ["Cargar Puntos", 2], ["Quitar Puntos", 3], ["Devolución de Puntos", 4], ["Consumir Puntos", 5]]
  #
  # Retorna un Array con los ids disponibles.
  def self.all
    OPERATIONS.map{|i| [i[:name], i[:id]]}
  end

  # Internal: Función de Clase. Entrega el id de la operación que permite que el
  #           usuario consuma/gaste sus puntos. ("que el cliente gaste")
  #
  # Retorna un Integer.
  def self.expend_id
    5
  end
end