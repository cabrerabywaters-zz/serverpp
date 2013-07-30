module Api
  class Cmr::Event < WashOut::Type
    map event_id: :integer, name: :string, details: :string, summary: :string, conditions: :string,
        exchange_mechanism: :string, ending_at: :date, validity_starting_at: :date, validity_ending_at: :date,
        starting_at: :date, interest: [Api::Cmr::Interests], place: :string, comuna: :string,
        exchange: [Api::Cmr::Exchanges],
        quantity: :integer, swaps: :integer, category: Api::Cmr::Category, eco: Api::Cmr::Eco,
        number_of_issued: :integer, exclusivity_id: :integer,
        image_original_url: :string, image_medium_url: :string, image_small_url: :string, image_thumb_url: :string

    def self.fetch efi, event_id
      event = efi.events.includes(experience: [:interests, :category]).includes(:exchanges).find(event_id)
      experience = event.experience
      {
        value: {
          event_id: event.id,  name: experience.name, details: experience.details,
          ending_at: experience.ending_at, validity_starting_at: experience.validity_starting_at,
          validity_ending_at: experience.validity_ending_at, quantity: event.quantity, swaps: event.swaps,
          category: Api::Cmr::Category.fetch(experience.category), eco: Api::Cmr::Eco.fetch(experience.eco),
          interest: Api::Cmr::Interests.fetch(experience), exchange: Api::Cmr::Exchanges.fetch(event.exchanges), image_original_url: experience.image_url(:original),
          image_medium_url: experience.image_url(:medium), image_small_url: experience.image_url(:small),
          image_thumb_url: experience.image_url(:thumb), exchange_mechanism: experience.exchange_mechanism,
          conditions: experience.conditions, summary: experience.summary, exclusivity_id: event.exclusivity_id,
          number_of_issued: experience.number_of_issued
        }
      }
    end
  end
end