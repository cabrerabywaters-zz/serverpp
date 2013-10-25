# Modulo que encapsula la API
module Api
  # Clase para manejar las Intereses como un tipo de dato valido para la API
  class Cmr::Interests < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'interests'

    # List of attributes returned by this Class
    map name: :string

    # Método que permite obtener el detalle de los Intereses de una experiencia, en un formato legible por la API
    #
    # @parametros:
    # Experience      experience       -  Una instancia de una Experiencia
    def self.fetch experience
      experience.interests.map { |i| { name: i.name } }
    end
  end
end