# Modulo que encapsula la API
module Api
  # Clase para manejar los Eventos como un tipo de dato valido para la API
  class Cmr::Event < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'event'

    # List of attributes returned by this Class
    map event_id: :integer, name: :string, details: :string, summary: :string, conditions: :string,
        exchange_mechanism: :string, ending_at: :date, validity_starting_at: :date, validity_ending_at: :date,
        starting_at: :date, interest: [Api::Cmr::Interests], place: :string, comuna: :string,
        exchange: [Api::Cmr::Exchanges],
        quantity: :integer, swaps: :integer, category: Api::Cmr::Category, eco: Api::Cmr::Eco,
        number_of_issued: :integer, exclusivity_id: :integer,
        image_original_url: :string, image_medium_url: :string, image_small_url: :string, image_thumb_url: :string,
        out_of_stock_at: :datetime

    # Método que permite obtener el detalle de un Evento, en un formato legible por la API
    #
    # @parametros:
    # EFI      efi       -  Una instancia de una EFI
    # Integer  event_id  -  Id del evento que se quiere consultar
    def self.fetch efi, event_id
      event =  efi.events
                  .are_published
                  .started
                  .includes(experience: [:interests, :category])
                  .includes(:exchanges)
                  .find(event_id)

      experience = event.experience

      {
        value: {
          event_id: event.id,
          name: experience.name,
          details: experience.details,
          ending_at: experience.ending_at,
          validity_starting_at: experience.validity_starting_at,
          validity_ending_at: experience.validity_ending_at,
          starting_at: experience.starting_at,
          quantity: event.quantity,
          swaps: event.swaps,
          category: Api::Cmr::Category.fetch(experience.category),
          eco: Api::Cmr::Eco.fetch(experience.eco),
          interest: Api::Cmr::Interests.fetch(experience),
          place: experience.place,
          comuna: experience.comuna_name,
          exchange: Api::Cmr::Exchanges.fetch(event.exchanges),
          image_original_url: experience.image_url(:original),
          image_medium_url: experience.image_url(:medium),
          image_small_url: experience.image_url(:small),
          image_thumb_url: experience.image_url(:thumb),
          exchange_mechanism: experience.exchange_mechanism,
          conditions: experience.conditions,
          summary: experience.summary,
          exclusivity_id: event.exclusivity_id,
          number_of_issued: experience.number_of_issued,
          out_of_stock_at: event.sold_at.presence ? I18n.l(event.sold_at.localtime, format: :api) : nil
        }
      }
    end
  end
end