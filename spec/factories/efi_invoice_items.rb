# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :efi_invoice_item do
    efi_invoice nil
    experience nil
    stock 1
    price 1
    comision 1.5
    total 1.5
  end
end
