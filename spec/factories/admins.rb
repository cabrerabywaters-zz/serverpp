# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    sequence(:names)           { |n| "admin#{n}"             }
    sequence(:rut)             { Run.for(:admin, :rut)       }
    sequence(:first_lastname)  { |n| "primer_apellido#{n}"   }
    sequence(:nickname)        { |n| "admin#{n}"             }

    sequence(:email)           { |n| "admin#{n}@example.com" }
    password                   '12345678'
    password_confirmation      '12345678'

    second_lastname            "MyString"
    
    initialize_with { Admin.find_or_create_by_email(email) }
  end
end
