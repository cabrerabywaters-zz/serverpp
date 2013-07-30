# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publicity do
    comment 'Lorem ipsum'
    image   { File.new(Rails.root + 'spec/fixtures/publicities/publicity.jpeg') }
    state   "pending"
    event
  end
end
