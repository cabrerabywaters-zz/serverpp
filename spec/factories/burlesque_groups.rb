# Read about factories at https://github.com/thoughtbot/factory_girl

# Good's Factories
FactoryGirl.define do
  factory :burlesque_group, class: Burlesque::Group do
    sequence(:name) { |n| "Good #{n}" }

    after(:build) do |user|
      user.roles << Burlesque::Role.find_or_create_by_name('all#manage')
    end
  end
end
