# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :eco do
    sequence(:rut)     { Run.for(:eco, :rut)                                 }
    sequence(:name)    { |n| "ECO #{n}"                                      }
    logo               { File.new(Rails.root + 'spec/fixtures/eco_logo.jpg') }
    sequence(:webpage) { "http://www.eco#{1}.cl" }

    bigger true

    sequence(:fancy_name) { |n| "ECO #{n} LTDA" }
    address "avenida siempre viva 742"
    discount 20
    fee      10

    admin
    comuna

    images true
  end
end
