# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experience do
    sequence(:name)      { |n| "experience_#{n}" }
    sequence(:details)   { Lorem::Base.new(:paragraphs, 2).output.split(%r{\n+}).map {|p| '<p>' + p + '</p>'}.join("\n") }
    sequence(:place)     { Lorem::Base.new(:words, 10).output }
    image                { File.new(Rails.root + 'spec/fixtures/experience.jpg') }
    starting_at          Date.current
    validity_starting_at Date.current
    ending_at            Date.current + 10.day
    validity_ending_at   Date.current + 10.day
    swaps                10
    codes_by_purchase    1
    sequence(:summary)   { Lorem::Base.new(:words, 5).output }

    amount               1000
    discounted_price     1
    # discount_percentage  10

    codes                ['a1', 'b2', 'c3', 'd4', 'e5', 'f6', 'g7', 'h8', 'i9', 'j0']

    eco
    category
    comuna

    state 'published'

    total_exclusivity_sales       true
    by_industry_exclusivity_sales true
    without_exclusivity_sales     true

    total_exclusivity_days       2
    by_industry_exclusivity_days 2
    without_exclusivity_days     2

    # Se asume que la ECO tiene un porcentaje de 20 o inferior
    fee  20

    sequence(:conditions){ Lorem::Base.new(:paragraphs, 2).output.split(%r{\n+}).map {|p| '<p>' + p + '</p>'}.join("\n") }
    exchange_mechanism 'Con papeles en mano'


    after(:build) do |e|
      e.industry_experiences << FactoryGirl.build(:industry_experience, experience_id: e.id, percentage: 100.0) unless e.pending?
      e.valid_images << FactoryGirl.build(:valid_image, experience_id: e.id) if e.eco_id.presence and e.eco.images?
    end
  end
end
