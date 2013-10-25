# Modulo que encapsula la API
module Api
  # Clase para manejar las ECO como un tipo de dato valido para la API
  class Cmr::Eco < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'eco'

    # List of attributes returned by this Class
    map fancy_name: :string, logo_original_url: :string, logo_thumb_url: :string, webpage: :string, address: :string

    # Método que permite obtener el detalle de una ECO, en un formato legible por la API
    #
    # @parametros:
    # ECO  eco  -  Una instancia de una ECO
    def self.fetch eco
      {
        fancy_name: eco.fancy_name,
        logo_original_url: eco.logo_url(:original),
        logo_thumb_url: eco.logo_url(:thumb),
        webpage: eco.webpage,
        address: eco.address
      }
    end

  end
end