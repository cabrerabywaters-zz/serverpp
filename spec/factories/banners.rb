# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :banner do
    event
    image     { File.new(Rails.root + 'spec/fixtures/banner.jpg') }
    published true
  end
end
