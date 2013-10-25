# Modulo que encapsula la API
module Api
  # Clase para manejar las Formas de Canje como un tipo de dato valido para la API
  class Cmr::Exchanges < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'exchanges'

    # List of attributes returned by this Class
    map exchange_id: :integer, points: :integer, cash: :integer

    # Método que permite obtener el detalle de las Formas de Canje, en un formato legible por la API
    #
    # @parametros:
    # Array      exchanges       -  Una arreglo con instancias de un Exchange
    def self.fetch exchanges
      exchanges.map { |exchange| { exchange_id: exchange.id, points: exchange.points, cash: exchange.cash } }
    end
  end
end