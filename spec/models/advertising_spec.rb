# encoding: utf-8
require 'spec_helper'

describe Advertising do
  ##############
  # attributes #
  ##############
  it "debe responder a name" do
    should respond_to :name
  end

  it "debe responder a image" do
    should respond_to :image
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe tener muchos experience_advertisings" do
      should have_many(:experience_advertisings).dependent(:destroy)
    end

    it "debe tener muchos experiences" do
      should have_many(:experiences).through(:experience_advertisings)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:advertising).should be_valid
  end

  describe ":name validations" do
    it "debe requerir un name" do
      FactoryGirl.build(:advertising, name: nil).should_not be_valid
      FactoryGirl.build(:advertising, name: '').should_not be_valid
    end

    it "debe requerir un name único" do
      FactoryGirl.create(:advertising, name: 'alfa')
      FactoryGirl.build(:advertising,  name: 'alfa').should_not be_valid
    end
  end

  it "debe requerir un image" do
    should validate_attachment_presence(:image)
  end

  # it "debe validar el contenido del image" do
  #   should validate_attachment_content_type(:image).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml')
  # end
  # it "debe validar el tamaño del image" do
  #   should validate_attachment_size(:image).less_than(2.megabytes)
  # end

  ###########
  # methods #
  ###########
end
