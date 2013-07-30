# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    operation_id 1
    points 1000
    account
  end
end
