# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    efi
    points 1000
    sequence(:rut) { Run.for(:account, :rut) }
    sequence(:name) {|n| "account_#{n}" }
    password '12345678'
  end
end
