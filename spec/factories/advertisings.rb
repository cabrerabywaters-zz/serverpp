# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :advertising do
    sequence(:name) { |n| "Advertising #{n}" }
    image { File.new(Rails.root + 'spec/fixtures/advertisings/television.png') }
  end
end
