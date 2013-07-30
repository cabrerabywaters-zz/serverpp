# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}"                                 }
    icon            { File.new(Rails.root + 'spec/fixtures/category.ico') }
    texture_name    { Category::TEXTURES.last }
  end
end
