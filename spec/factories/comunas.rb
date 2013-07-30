# Read about factories at https://github.com/thoughtbot/factory_girl

# encoding: utf-8
FactoryGirl.define do
  factory :comuna, class: ChileanCities::Comuna do
    name          "Camarones"
    code          "15102"
    provincia     "Arica"
    region        "Arica y Parinacota"
    region_number "XV"
  end
end
