# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experience_code do
    type ""
    code "MyString"
    purchase nil
    sold_at "2013-10-23 10:57:29"
    validated_at "2013-10-23 10:57:29"
  end
end
