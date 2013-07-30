# encoding: utf-8
require 'spec_helper'

describe ExperienceAdvertising do
  ##############
  # attributes #
  ##############
  it "debe responder a experience_id" do
    should respond_to :experience_id
  end

  it "debe responder a advertising_id" do
    should respond_to :advertising_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a advertising" do
    should belong_to(:advertising)
  end

  it "debe pertenecer a experience" do
    should belong_to(:experience)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:experience_advertising).should be_valid
  end

  it "debe requerir un :advertising_id" do
    FactoryGirl.build(:experience_advertising, advertising_id: nil).should_not be_valid
    FactoryGirl.build(:experience_advertising, advertising_id: '').should_not be_valid
  end

  context "al actualizar" do
    it "debe requerir un experience_id" do
      experience_advertising = FactoryGirl.create(:experience_advertising)

      experience_advertising.experience_id = nil
      experience_advertising.should_not be_valid

      experience_advertising.experience_id = ''
      experience_advertising.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un experience_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear un Experience y asignarle Advertising's"
    end
  end

  it "debe validar de forma única la combinación advertising_id y experience_id" do
    experience  = FactoryGirl.create(:experience)
    advertising = FactoryGirl.create(:advertising)

    FactoryGirl.create(:experience_advertising, experience_id: experience.id, advertising_id: advertising.id)
    FactoryGirl.build(:experience_advertising,  experience_id: experience.id, advertising_id: advertising.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
end
