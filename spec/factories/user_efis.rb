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
  
  factory :efi_user, class: UserEfi do
    # ignore do
    #   industry_name 'Industry'
    # end
    
    names 'Default Names'
    first_lastname "EFI"
    second_lastname "User"
    sequence(:rut) { Run.for(:user_efi, :rut) }    
    
    nickname { names.downcase.gsub(' ', '_') }
    email { "#{nickname}@efi.com" }
    password { "efiuser123" }
    password_confirmation { "efiuser123" }
    
    mod_client true
    
    initialize_with { UserEfi.find_or_initialize_by_email(email) }
    
    # after(:build) do |u, evaluator|
    #   u.efi = FactoryGirl.create(:efinew, name: u.names, industry_name: evaluator.industry_name)
    # end
  end
end
