# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    # quantity 10
    # swaps 1
    exclusivity_id 1
    efi
    experience

    state 'published'

    after(:build) do |e|
      e.exchanges << FactoryGirl.build(:exchange, event: e)
      if e.efi.presence and e.experience.presence and not e.experience.available_efis.include?(e.efi)
        e.experience.available_efis << e.efi
      end
    end
  end
  
  factory :efi_purchase, class: Event do
    exclusivity_id 1
    efi factory: :efinew
    experience
    state 'published'
    
    after(:build) do |p|
      p.exchanges = [FactoryGirl.build(:exchange, points: 100, cash: 0)]
      p.experience.available_efis = [p.efi]
    end
  end
end
