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
  
  factory :eco_user, class: UserEco do
    sequence(:rut) { Run.for(:user_eco, :rut) }
    names "Default ECO User Names"
    first_lastname "ECO"
    second_lastname "User"
    nickname { names.downcase.gsub(/\s+/, '') }
    
    
    email { "#{nickname}@eco.com" }
    password "ecouser123"
    password_confirmation "ecouser123"
    
    after(:build) do |user|
      # user.eco = FactoryGirl.build(:econew, name: user.names)
      user.groups = [FactoryGirl.build(:admin_group)] unless user.group.present?
    end
    
    initialize_with { UserEco.find_or_initialize_by_names(names) }
  end
end
