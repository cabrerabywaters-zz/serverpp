# encoding: utf-8
require 'spec_helper'

describe Banner do
  describe "attributes" do
    it "debe responder a event_id" do
      should respond_to :event_id
    end

    it "debe responder a image" do
      should respond_to :image
    end

    it "debe responder a published" do
      should respond_to :published
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe pertenecer a event" do
      should belong_to(:event)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:banner).should be_valid
  end

  it "debe requerir un event_id" do
    FactoryGirl.build(:banner, event_id: nil).should_not be_valid
    FactoryGirl.build(:banner, event_id: '').should_not be_valid
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
  describe 'para filtrar Events' do
    it "deberia responder a published" do
      Banner.should respond_to :published
    end
  end
end
