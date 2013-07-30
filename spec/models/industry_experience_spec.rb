# encoding: utf-8
require 'spec_helper'

describe IndustryExperience do

  ##############
  # attributes #
  ##############
  describe "attributes" do
    it "debe responder a industry_id" do
      should respond_to :industry_id
    end

    it "debe responder a experience_id" do
      should respond_to :experience_id
    end

    it "debe responder a percentage" do
      should respond_to :percentage
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe pertenecer a industry" do
      should belong_to(:industry)
    end

    it "debe pertenecer a experience" do
      should belong_to(:experience)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:industry_experience).should be_valid
  end

  it "debe requerir un industry_id" do
    FactoryGirl.build(:industry_experience, industry_id: nil).should_not be_valid
    FactoryGirl.build(:industry_experience, industry_id: '').should_not be_valid
  end

  describe "percentage" do
    it "debe requerir un percentage" do
      FactoryGirl.build(:industry_experience, percentage: nil).should_not be_valid
      FactoryGirl.build(:industry_experience, percentage: '').should_not be_valid
    end

    it "debe requerir un percentage numerico" do
      should validate_numericality_of(:percentage)
      FactoryGirl.build(:industry_experience, percentage: 'a').should_not    be_valid
    end

    it "debe requerir un percentage mayor o igual a cero" do
      FactoryGirl.build(:industry_experience, percentage: '-1').should_not   be_valid
      FactoryGirl.build(:industry_experience, percentage: -1).should_not     be_valid
      FactoryGirl.build(:industry_experience, percentage: '-1.5').should_not be_valid
      FactoryGirl.build(:industry_experience, percentage: -1.5).should_not   be_valid

      FactoryGirl.build(:industry_experience, percentage: '0').should   be_valid
      FactoryGirl.build(:industry_experience, percentage: 0).should     be_valid
      FactoryGirl.build(:industry_experience, percentage: '1').should   be_valid
      FactoryGirl.build(:industry_experience, percentage: 1).should     be_valid
      FactoryGirl.build(:industry_experience, percentage: '1.5').should be_valid
      FactoryGirl.build(:industry_experience, percentage: 1.5).should   be_valid
    end

    it "debe requerir un percentage menor o igual a cien" do
      FactoryGirl.build(:industry_experience, percentage: '101').should_not   be_valid
      FactoryGirl.build(:industry_experience, percentage:  101).should_not    be_valid
      FactoryGirl.build(:industry_experience, percentage: '100.1').should_not be_valid
      FactoryGirl.build(:industry_experience, percentage:  100.1).should_not  be_valid

      FactoryGirl.build(:industry_experience, percentage: '100').should   be_valid
      FactoryGirl.build(:industry_experience, percentage:  100).should    be_valid
      FactoryGirl.build(:industry_experience, percentage:  '99').should   be_valid
      FactoryGirl.build(:industry_experience, percentage:   99).should    be_valid
      FactoryGirl.build(:industry_experience, percentage:  '99.9').should be_valid
      FactoryGirl.build(:industry_experience, percentage:   99.9).should  be_valid
    end
  end

  context "al actualizar" do
    it "debe requerir un experience_id" do
      industry_experience = FactoryGirl.create(:industry_experience)

      industry_experience.experience_id = nil
      industry_experience.should_not be_valid

      industry_experience.experience_id = ''
      industry_experience.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un experience_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear una Experience y asignarle porcentajes a las Industries"
    end
  end

  it "debe validar de forma única la combinacion Industry & Experience" do
    experience = FactoryGirl.create(:experience)
    industry   = FactoryGirl.create(:industry)

    FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry.id)
    FactoryGirl.build(:industry_experience,  experience_id: experience.id, industry_id: industry.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
end
