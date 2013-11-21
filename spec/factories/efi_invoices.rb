# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :efi_invoice do
    efi nil
    total 1.5
    state "MyString"
    billing_started_at "2013-11-08 09:58:47"
    billing_ended_at "2013-11-08 09:58:47"
    paid_at "2013-11-08 09:58:47"
  end
end
