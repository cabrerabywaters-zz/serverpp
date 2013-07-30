# encoding: utf-8
require 'spec_helper'

describe Publicity do
  describe "attributes" do
    it "debe responder a comment" do
      should respond_to :comment
    end

    it "debe responder a image" do
      should respond_to :image
    end

    it "debe responder a state" do
      should respond_to :state
    end

    it "debe responder a event_id" do
      should respond_to :event_id
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
    FactoryGirl.build(:publicity).should be_valid
  end

  it "debe requerir un event_id" do
    FactoryGirl.build(:publicity, event_id: nil).should_not be_valid
    FactoryGirl.build(:publicity, event_id: '').should_not be_valid
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

  it "debe requerir un comment cuando se rechaza una publicity" do
    FactoryGirl.build(:publicity, state: 'rejected', comment: nil).should_not be_valid
    FactoryGirl.build(:publicity, state: 'rejected', comment: '').should_not be_valid
  end

  ###########
  # methods #
  ###########
  context 'para obtener el estado en que se encuentra la Publicity' do
    it "debe responder a translate_state" do
      should respond_to :translate_state
    end

    it "debe responder con una traducción legible" do
      publicity = FactoryGirl.create(:publicity)
      ['pending', 'accepted', 'rejected'].each do |s|
        publicity.state = s
        publicity.translate_state.include?('translation missing:').should be_false
      end

      publicity.state = 'estado_no_existente'
      publicity.translate_state.include?('translation missing:').should be_false
      publicity.translate_state.should eq('estado_no_existente')
    end
  end

  context "para saber el tipo del arhivo" do
    it "debe responder a is_image?" do
      should respond_to :is_image?
    end

    it "debe responder a is_pdf?" do
      should respond_to :is_pdf?
    end

    it "debe responder a is_office?" do
      should respond_to :is_office?
    end

    it "debe responder a is_compressed_file?" do
      should respond_to :is_compressed_file?
    end

    it "debe responder con un valor correcto" do
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.jpeg')).is_image?.should be_true
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.pdf')).is_pdf?.should be_true
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.docx')).is_office?.should be_true
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.zip')).is_compressed_file?.should be_true
    end
  end

  context "para saber que imagen mostrar" do
    it "debe responder a file_representation" do
      should respond_to :file_representation
    end

    it "debe responder con un valor correcto" do
      publicity = FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.jpeg'))
      publicity.file_representation.should eq(publicity.image.url)

      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.pdf')).file_representation.should eq('publicities/pdf.png')
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.docx')).file_representation.should eq('publicities/office.png')
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.zip')).file_representation.should eq('publicities/zip.png')
      FactoryGirl.build(:publicity, image: File.new(Rails.root + 'spec/fixtures/publicities/publicity.txt')).file_representation.should eq('publicities/file.png')
    end
  end

  #################
  # state_machine #
  #################
  describe "state_machine" do
    context "states" do
      it "debe tener estados" do
        FactoryGirl.create(:publicity, state: 'pending').should be_valid
        FactoryGirl.create(:publicity, state: 'accepted').should be_valid
        FactoryGirl.create(:publicity, state: 'rejected').should be_valid

        expect {
          FactoryGirl.create(:publicity, state: 'otro_estado_no_valido')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "events" do
      describe "accept!" do
        it "debe cambiar el estado" do
          publicity = FactoryGirl.create(:publicity, state: 'pending')
          publicity.accept!.should be_true
          publicity.accepted?.should be_true
        end

        it "no debe cambiar el estado" do
          ['accepted', 'rejected'].each do |s|
            publicity = FactoryGirl.create(:publicity, state: s)
            publicity.accept!.should be_false
          end
        end
      end

      describe "reject!" do
        it "debe cambiar el estado" do
          publicity = FactoryGirl.create(:publicity, state: 'pending')
          publicity.reject!.should be_true
          publicity.rejected?.should be_true
        end

        it "no debe cambiar el estado" do
          ['accepted', 'rejected'].each do |s|
            publicity = FactoryGirl.create(:publicity, state: s)
            publicity.reject!.should be_false
          end
        end
      end
    end

    context "transitions" do
    end
  end
end
