# Modulo que encapsula la API
module Api
  # Clase para manejar las categorías como un tipo de dato valido para la API
  class Cmr::Category < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'category'

    # List of attributes returned by this Class
    map name: :integer, icon_url: :string

    # Método que permite obtener el detalle de una Categoria, en un formato legible por la API
    #
    # @parametros:
    # Category  category  -  Una instancia de una Categoria
    def self.fetch category
      { name: category.name, icon_url: category.icon_url }
    end
  end
end