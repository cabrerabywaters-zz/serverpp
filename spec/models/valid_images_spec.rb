# encoding: utf-8
require 'spec_helper'

describe ValidImage do
  ##############
  # attributes #
  ##############
  it "debe responder a experience_id" do
    should respond_to :experience_id
  end

  it "debe responder a image" do
    should respond_to :image
  end

  ################
  # associations #
  ################
  it "debe pertenecer a experience" do
    should belong_to(:experience)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:valid_image).should be_valid
  end

  context "al actualizar" do
    it "debe requerir un experience_id" do
      valid_image = FactoryGirl.create(:valid_image)

      valid_image.experience_id = nil
      valid_image.should_not be_valid

      valid_image.experience_id = ''
      valid_image.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un experience_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear una Experience y asignarle EFI's"
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
