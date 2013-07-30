# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_eco do
    sequence(:rut)             { Run.for(:user_eco, :rut)       }
    sequence(:names)           { |n| "user_eco#{n}"             }
    sequence(:first_lastname)  { |n| "primer_apellido#{n}"      }
    sequence(:nickname)        { |n| "user_eco#{n}"             }

    sequence(:email)           { |n| "user_eco#{n}@example.com" }
    password                   '12345678'
    password_confirmation      '12345678'

    second_lastname            "MyString"

    eco

    after(:build) do |user|
      user.groups << FactoryGirl.build(:burlesque_group) unless user.group.presence
    end
  end
end
