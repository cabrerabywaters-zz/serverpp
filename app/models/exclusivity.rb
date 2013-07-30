# encoding: utf-8

# Public: Clase estática que permite mantener desacoplado el funcionamiento de
#         la exclusividad de un evento.
#
# @public Exclusivity initialize(attributes) Constructor de la clase.
#
# @public Array ids() Función de Clase. Permite obtener todos los ids disponibles.
#
# @public Exclusivity find() Función de Clase. Permite buscar una exclusividad.
#
# @private Integer total_id() Función de Clase. Entrega el id de la 'exclusividad total'.
#
# @private Integer by_industry_id() Función de Clase. Entrega el id de la 'exclusividad por industria'.
#
# @private Integer without_id() Función de Clase. Entrega el id de 'sin exclusividad'.
#
class Exclusivity
  # Providing the functionality that ActiveModel::Naming provides in your object is required to pass the Active Model Lint test. So either extending the provided method below, or rolling your own is required.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Naming.html
  extend ActiveModel::Naming
  # This also provides the required class methods for hooking into the Rails internationalization API, including being able to define a class based i18n_scope and lookup_ancestors to find translations in parent classes.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Translation.html
  extend ActiveModel::Translation
  # Handles default conversions: #to_model, #to_key, #to_param, and to_partial_path.
  # More information on http://api.rubyonrails.org/classes/ActiveModel/Conversion.html
  include ActiveModel::Conversion

  # Mas información en: http://www.rubyist.net/~slagell/ruby/accessors.html
  attr_accessor :id,
                :name

  # Internal: Constructor de la clase.
  #           Entrega una instancia de la clase Exclusivity.
  #
  #
  # @parametros:
  # Hash attributes - Los datos de la exclusividad misma estos deben contener
  #                   :id y :name.
  #
  # Ejemplo
  #
  #   Exclusivity.new {id: 1, name: 'Exclusividad Total'}
  #   # => #<Exclusivity:0x007f9b41242a28 @id="1", @name="Exclusividad Total">
  #
  # Retorna una instancia de Exclusivity
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

  # HASH con la definición estática de las diferentes exclusividad disponibles
  EXCLUSIVITIES = [ {id: 1, name: 'Exclusividad Total'         },
                    {id: 2, name: 'Exclusividad por Industria' },
                    {id: 3, name: 'Sin Exclusividad'           } ]

  # Internal: Función de Clase. Permite obtener todos los ids disponibles.
  #
  # Ejemplo
  #
  #   Exclusivity.ids
  #   # => [1, 2, 3]
  #
  # Retorna un Array con los ids disponibles.
  def self.ids
    EXCLUSIVITIES.map{ |i| i[:id] }
  end

  # Internal: Función de Clase. Permite buscar una exclusividad.
  #
  # Ejemplo
  #
  #   Exclusivity.find(1)
  #   # => #<Exclusivity:0x007f9b41242a28 @id="1", @name="Exclusividad Total">
  #
  # Retorna un Array con los ids disponibles.
  def self.find id
    if ids.include? id
      Exclusivity.new EXCLUSIVITIES[id-1]
    end
  end

  # Internal: Función de Clase. Entrega el id de la 'exclusividad total'.
  #
  # Retorna un Integer.
  def self.total_id
    1
  end

  # Internal: Función de Clase. Entrega el id de la 'exclusividad por industria'.
  #
  # Retorna un Integer.
  def self.by_industry_id
    2
  end

  # Internal: Función de Clase. Entrega el id de 'sin exclusividad'.
  #
  # Retorna un Integer.
  def self.without_id
    3
  end
end