module Api
  # Public: Event List for CMR integration.
  #
  #
  class Cmr::EventList < WashOut::Type
    include Rails.application.routes.url_helpers
    type_name 'eventList'

    # List of attributes returned by the Webservice
    map event_id: :integer, event_name: :string, ending_at: :date,
        exchange: [Api::Cmr::Exchanges], category: Api::Cmr::Category,
        image_original_url: :string, image_medium_url: :string, image_small_url: :string, image_thumb_url: :string
    # Format attributes for return
    def self.fetch efi
      events = efi.events.are_published.started.includes(experience: :category).includes(:exchanges).order(:id).map { |e|
        {
          event_id: e.id,
          event_name: e.experience.name,
          ending_at: e.experience.ending_at,
          exchanges: Api::Cmr::Exchanges.fetch(e.exchanges),
          category: Api::Cmr::Category.fetch(e.experience.category),
          image_original_url: e.experience.image_url(:original),
          image_medium_url: e.experience.image_url(:medium),
          image_small_url: e.experience.image_url(:small),
          image_thumb_url: e.experience.image_url(:thumb)
        }
      }
      return { value: events }
    end

    private

    def self.cash_and_points event
      event.exchanges.map { |exchange| { exchange: {points: exchange.points, cash: exchange.cash } } }
    end
  end
end