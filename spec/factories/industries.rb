# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :industry do
    sequence(:name) { |n| "Industry #{n}" }
    # initialize_with { Industry.find_or_initialize_by_name(name) } # Create only if not exists
  end
end
