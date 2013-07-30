# encoding: utf-8
require 'spec_helper'

describe Industry do
  ##############
  # attributes #
  ##############
  it "debe responder a name" do
    should respond_to :name
  end

  it "debe responder a percentage" do
    should respond_to :percentage
  end

  ################
  # associations #
  ################
  it "debe tener muchos industry_efis" do
    should have_many(:industry_efis).dependent(:destroy)
  end

  it "debe tener muchos efis" do
    should have_many(:efis).through(:industry_efis)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:industry).should be_valid
  end

  it "debe requerir un name" do
    FactoryGirl.build(:industry, name: nil).should_not be_valid
    FactoryGirl.build(:industry, name: '').should_not be_valid
  end

  it "debe requerir un name único" do
    FactoryGirl.create(:industry, name: 'alfa')
    FactoryGirl.build(:industry,  name: 'alfa').should_not be_valid
  end

  describe "validations on :percentage" do
    it "debe setear por defecto el percentage" do
      FactoryGirl.build(:industry,  percentage: nil).should be_valid
      FactoryGirl.build(:industry,  percentage: '').should  be_valid
    end

    it "debe requerir un percentage valido" do
      FactoryGirl.create(:industry)
      FactoryGirl.build(:industry,  percentage: 100).should_not be_valid
      FactoryGirl.build(:industry,  percentage: 1).should_not   be_valid
      FactoryGirl.build(:industry,  percentage: 0).should       be_valid
    end
  end

  ###########
  # methods #
  ###########
end
