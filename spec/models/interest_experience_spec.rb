# encoding: utf-8
require 'spec_helper'

describe InterestExperience do
  ##############
  # attributes #
  ##############
  it "debe responder a interest_id" do
    should respond_to :interest_id
  end

  it "debe responder a experience_id" do
    should respond_to :experience_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a interest" do
    should belong_to(:interest)
  end

  it "debe pertenecer a experience" do
    should belong_to(:experience)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:interest_experience).should be_valid
  end

  it "debe requerir un industry_id" do
    FactoryGirl.build(:interest_experience, interest_id: nil).should_not be_valid
    FactoryGirl.build(:interest_experience, interest_id: '').should_not be_valid
  end

  context "al actualizar" do
    it "debe requerir un experience_id" do
      interest_experience = FactoryGirl.create(:interest_experience)

      interest_experience.experience_id = nil
      interest_experience.should_not be_valid

      interest_experience.experience_id = ''
      interest_experience.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un experience_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear un Experience y asignarle Interests"
    end
  end

  it "debe validar de forma única la combinación interest_id y experience_id" do
    interest   = FactoryGirl.create(:interest)
    experience = FactoryGirl.create(:experience)

    FactoryGirl.create(:interest_experience, experience_id: experience.id, interest_id: interest.id)
    FactoryGirl.build(:interest_experience,  experience_id: experience.id, interest_id: interest.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
end
