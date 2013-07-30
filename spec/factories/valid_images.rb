# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :valid_image do
    image { File.new(Rails.root + 'spec/fixtures/experience.jpg') }
    experience
  end
end
