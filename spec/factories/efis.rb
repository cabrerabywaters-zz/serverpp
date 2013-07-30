# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :efi do
    sequence(:rut)         { Run.for(:efi, :rut)                                 }
    sequence(:name)        { |n| "EFI #{n}"                                      }
    logo                   { File.new(Rails.root + 'spec/fixtures/efi_logo.jpg') }
    sequence(:zona)        { Lorem::Base.new(:words, 1).output }
    sequence(:search_name) { |n| "efi#{n}" }
    connector_name         'BaseConnector'
    compared               true

    after(:build) do |e|
      e.industry_efis << FactoryGirl.build(:industry_efi, efi_id: e.id)
    end
  end
end
