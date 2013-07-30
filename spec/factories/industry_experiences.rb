# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :industry_experience do
    industry
    experience
    percentage 10.0
  end
end
