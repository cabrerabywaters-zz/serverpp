# coding: utf-8

def clean(str)
  str.downcase.gsub(/\s+/, '')
end

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

  factory :econew, class: Eco do
    sequence(:rut) { Run.for(:eco, :rut) }
    name "Default ECO Name"
    logo { File.new(Rails.root.join('db', 'images', 'eco', "#{clean(name)}.png")) }
    webpage { "http://www.#{clean(name)}.cl" }
    bigger true
    fancy_name { name }
    address "Av. Los Leones 123"
    discount 20
    fee 10

    admin { create(:admin, names: name, first_lastname: "ECO", second_lastname: "Admin", nickname: "admin#{clean(name)}", email: "admin@#{clean(name)}.cl", password: "admin123", password_confirmation: "admin123") }
    comuna factory: :santiago

    images true

    initialize_with { Eco.find_or_initialize_by_name(name) }
  end
end