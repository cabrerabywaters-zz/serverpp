# encoding: utf-8
require 'spec_helper'

describe IndustryEfi do
  ##############
  # attributes #
  ##############
  it "debe responder a industry_id" do
    should respond_to :industry_id
  end

  it "debe responder a efi_id" do
    should respond_to :efi_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a industry" do
    should belong_to(:industry)
  end

  it "debe pertenecer a efi" do
    should belong_to(:efi)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:industry_efi).should be_valid
  end

  it "debe requerir un industry_id" do
    FactoryGirl.build(:industry_efi, industry_id: nil).should_not be_valid
    FactoryGirl.build(:industry_efi, industry_id: '').should_not be_valid
  end

  context "al actualizar" do
    it "debe requerir un efi_id" do
      industry_efi = FactoryGirl.create(:industry_efi)

      industry_efi.efi_id = nil
      industry_efi.should_not be_valid

      industry_efi.efi_id = ''
      industry_efi.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un efi_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear un EFI y asignarle Industries"
    end
  end

  it "debe validar de forma única la combinación industry_id y efi_id" do
    efi      = FactoryGirl.create(:efi)
    industry = FactoryGirl.create(:industry)

    FactoryGirl.create(:industry_efi, efi_id: efi.id, industry_id: industry.id)
    FactoryGirl.build(:industry_efi,  efi_id: efi.id, industry_id: industry.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
end
