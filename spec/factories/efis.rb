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

  # [:entel, :movistar, :claro, :falabella, :paris, :ripley, :bci, :santander, :bbva]
  factory :efinew, class: Efi do
    ignore do
      industry_name 'Industry'
    end
    
    sequence(:rut) { Run.for(:efi, :rut) }
    name "EFI Name"
    logo { File.new(Rails.root.join('db', 'images', 'efi', "#{name.downcase}.png"))}
    zona { "Puntos #{name}" }
    search_name { name.downcase }
    connector_name 'BaseConnector'
    compared true
    
    initialize_with { Efi.find_or_initialize_by_name(name) }

    # after(:build) do |e, evaluator|
    #   industry = FactoryGirl.build(:industry, name: evaluator.industry_name)
    #   e.industry_efis = [FactoryGirl.build(:industry_efi, efi_id: e.id, industry_id: industry.id)]
    # end
  end
end
