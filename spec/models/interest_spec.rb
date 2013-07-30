# encoding: utf-8
require 'spec_helper'

describe Interest do
  ##############
  # attributes #
  ##############
  it "debe responder a name" do
    should respond_to :name
  end

  ################
  # associations #
  ################
  it "debe tener muchos interest_experiences" do
    should have_many(:interest_experiences).dependent(:destroy)
  end

  it "debe tener muchos experiences" do
    should have_many(:experiences).through(:interest_experiences)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:interest).should be_valid
  end

  it "debe requerir un name" do
    FactoryGirl.build(:interest, name: nil).should_not be_valid
    FactoryGirl.build(:interest, name: '').should_not be_valid
  end

  it "debe requerir un name único" do
    FactoryGirl.create(:interest, name: 'alfa')
    FactoryGirl.build(:interest,  name: 'alfa').should_not be_valid
  end

  ###########
  # methods #
  ###########
end
