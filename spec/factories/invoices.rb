# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    eco nil
    start_at "2013-09-05"
    end_at "2013-09-05"
    income ""
    charge ""
    to_pay_double "MyString"
    state "MyString"
  end
end
