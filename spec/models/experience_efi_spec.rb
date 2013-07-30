# encoding: utf-8
require 'spec_helper'

describe ExperienceEfi do
   ##############
  # attributes #
  ##############
  it "debe responder a efi_id" do
    should respond_to :efi_id
  end

  it "debe responder a experience_id" do
    should respond_to :experience_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a experience" do
    should belong_to(:experience)
  end

  it "debe pertenecer a efi" do
    should belong_to(:efi)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:experience_efi).should be_valid
  end

  context "al actualizar" do
    it "debe requerir un experience_id" do
      experience_efi = FactoryGirl.create(:experience_efi)

      experience_efi.experience_id = nil
      experience_efi.should_not be_valid

      experience_efi.experience_id = ''
      experience_efi.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un experience_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear una Experience y asignarle EFI's"
    end
  end

  it "debe requerir un efi_id" do
    FactoryGirl.build(:experience_efi, efi_id: nil).should_not be_valid
    FactoryGirl.build(:experience_efi, efi_id: '').should_not be_valid
  end

  it "debe validar de forma única la combinación experience_id y efi_id" do
    efi      = FactoryGirl.create(:efi)
    experience = FactoryGirl.create(:experience)

    FactoryGirl.create(:experience_efi, efi_id: efi.id, experience_id: experience.id)
    FactoryGirl.build(:experience_efi,  efi_id: efi.id, experience_id: experience.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
end
