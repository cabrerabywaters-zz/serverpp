# coding: utf-8

FactoryGirl.define do
  factory :comuna, class: ChileanCities::Comuna do
    name          "Camarones"
    code          "15102"
    provincia     "Arica"
    region        "Arica y Parinacota"
    region_number "XV"
    initialize_with { ChileanCities::Comuna.find_or_initialize_by_name(name) }
  end
  
  factory :santiago, class: ChileanCities::Comuna do
    name "Santiago"
    code "13101"
    provincia "Santiago"
    region "Región Metropolitana de Santiago"
    region_number "XIII"
    initialize_with { ChileanCities::Comuna.find_or_initialize_by_name(name) }
  end
end
