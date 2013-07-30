# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    sequence(:rut)   { Run.for(:purchase, :rut)       }
    sequence(:email) { |n| "purchase#{n}@example.com" }
    password         '12345678'
    state            'sold'

    exchange
  end
end
