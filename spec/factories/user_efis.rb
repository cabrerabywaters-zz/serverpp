# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_efi do
    sequence(:names)           { |n| "user_efi#{n}"             }
    sequence(:rut)             { Run.for(:user_efi, :rut)       }
    sequence(:first_lastname)  { |n| "primer_apellido#{n}"      }
    sequence(:nickname)        { |n| "user_efi#{n}"             }

    sequence(:email)           { |n| "user_efi#{n}@example.com" }
    password                   '12345678'
    password_confirmation      '12345678'

    second_lastname            "MyString"
    mod_client                 true

    efi
  end
end
