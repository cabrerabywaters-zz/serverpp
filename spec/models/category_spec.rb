# encoding: utf-8
require 'spec_helper'

describe Category do
  ##############
  # attributes #
  ##############
  it "debe responder a name" do
    should respond_to :name
  end

  it "debe responder a icon" do
    should respond_to :icon
  end

  it "debe responder a texture_name" do
    should respond_to :texture_name
  end

  ################
  # associations #
  ################
  it "debe tener muchas experiences" do
    should have_many(:experiences).dependent(:destroy)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:category).should be_valid
  end

  it "debe requerir un name" do
    FactoryGirl.build(:category, name: nil).should_not be_valid
    FactoryGirl.build(:category, name: '').should_not be_valid
  end

  it "debe requerir un texture_name" do
    FactoryGirl.build(:category, texture_name: nil).should_not be_valid
    FactoryGirl.build(:category, texture_name: '').should_not be_valid
  end

  it "debe requerir un name único" do
    FactoryGirl.create(:category, name: 'alfa')
    FactoryGirl.build(:category,  name: 'alfa').should_not be_valid
  end

  it "debe requerir un icon" do
    should validate_attachment_presence(:icon)
  end

  # it "debe validar el contenido del icon" do
  #   should validate_attachment_content_type(:icon).allowing('image/icon')
  # end
  # it "debe validar el tamaño del icon" do
  #   should validate_attachment_size(:icon).less_than(2.megabytes)
  # end

  ###########
  # methods #
  ###########
end
