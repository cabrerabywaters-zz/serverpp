# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interest do
    sequence(:name) { |n| "Interest #{n}" }
  end
end
