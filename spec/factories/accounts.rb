# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    efi
    points 1000
    sequence(:rut) { Run.for(:account, :rut) }
    sequence(:name) {|n| "account_#{n}" }
    password '12345678'
  end
  
  factory :client, class: 'Account' do
    points 10000
    sequence(:rut) { Run.for(:account, :rut) }
    sequence(:name) {|n| "Cliente #{n}" }
    password 'cliente123'
    
    initialize_with { Account.find_or_initialize_by_name_and_efi_id(name, efi.id) }
  end
end
