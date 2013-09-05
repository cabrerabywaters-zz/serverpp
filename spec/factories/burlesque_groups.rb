# Read about factories at https://github.com/thoughtbot/factory_girl

# Good's Factories
FactoryGirl.define do
  factory :burlesque_group, class: Burlesque::Group do
    sequence(:name) { |n| "God #{n}" }

    after(:build) do |user|
      user.roles << Burlesque::Role.find_or_create_by_name('all#manage')
    end
  end
  
  factory :admin_group, class: Burlesque::Group do
    name 'Admin Group'
    
    after(:build) do |group|
      group.roles = [Burlesque::Role.find_or_initialize_by_name('all#manage')]
    end
    
    initialize_with { Burlesque::Group.find_or_initialize_by_name('Admin Group') }
  end
end
