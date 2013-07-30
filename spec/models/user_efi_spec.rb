# encoding: utf-8
require 'spec_helper'

describe UserEfi do
  ##############
  # attributes #
  ##############

  it "debe responder a email" do
    should respond_to :email
  end

  it "debe responder a password" do
    should respond_to :password
  end

  it "debe responder a first_lastname" do
    should respond_to :first_lastname
  end

  it "debe responder a names" do
    should respond_to :names
  end

  it "debe responder a nickname" do
    should respond_to :nickname
  end

  it "debe responder a rut" do
    should respond_to :rut
  end

  it "debe responder a second_lastname" do
    should respond_to :second_lastname
  end

  it "debe responder a efi_id" do
    should respond_to :efi_id
  end

  it "debe responder a mod_client" do
    should respond_to :mod_client
  end

  ################
  # associations #
  ################
  it "debe pertenecer a efi" do
    should belong_to(:efi)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:user_efi).should be_valid
  end

  it "debe requerir un first_lastname" do
    FactoryGirl.build(:user_efi, first_lastname: nil).should_not be_valid
    FactoryGirl.build(:user_efi, first_lastname: '').should_not be_valid
  end

  it "debe requerir un names" do
    FactoryGirl.build(:user_efi, names: nil).should_not be_valid
    FactoryGirl.build(:user_efi, names: '').should_not be_valid
  end

  it "debe requerir un id de efi" do
    FactoryGirl.build(:user_efi, efi_id: nil).should_not be_valid
    FactoryGirl.build(:user_efi, efi_id: '').should_not  be_valid
  end

  it "debe requerir un nickname" do
    FactoryGirl.build(:user_efi, nickname: nil).should_not be_valid
    FactoryGirl.build(:user_efi, nickname: '').should_not be_valid
  end

  it "debe requerir un nickname único" do
    FactoryGirl.create(:user_efi, nickname: 'alfa')
    FactoryGirl.build(:user_efi,  nickname: 'alfa').should_not be_valid
  end

  it "debe requerir un rut" do
    FactoryGirl.build(:user_efi, rut: nil).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '').should_not  be_valid
  end

  it "debe requerir un rut único" do
    FactoryGirl.create(:user_efi, rut: '11.111.111-1')
    FactoryGirl.build(:user_efi,  rut: '11.111.111-1').should_not be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:user_efi, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:user_efi, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:user_efi, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:user_efi, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:user_efi, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:user_efi, rut: Run.for(:user_efi, :rut)).should be_valid
  end

  ###########
  # methods #
  ###########
  describe 'efi_name' do
    it "debe responder a efi_name" do
      should respond_to :efi_name
    end
  end

  describe 'efi_logo' do
    it "debe responder a efi_logo" do
      should respond_to :efi_logo
    end
  end

  describe 'zona' do
    it "debe responder a zona" do
      should respond_to :zona
    end
  end

  describe 'available_experiences' do
    it "debe responder a available_experiences" do
      should respond_to :available_experiences
    end

    it "deberia mostrar solo las Experiences de la EFI a la que pertenece" do
      @user_efi = FactoryGirl.create(:user_efi)
      experience1 = FactoryGirl.create(:experience, available_efi_ids: ['', @user_efi.efi.id])
      experience2 = FactoryGirl.create(:experience)

      @user_efi.available_experiences.should eq [experience1]
    end
  end

  describe 'events' do
    it "debe responder a events" do
      should respond_to :events
    end

    it "deberia mostrar solo los Events de la EFI a la que pertenece" do
      @user_efi = FactoryGirl.create(:user_efi)
      event1 = FactoryGirl.create(:event, efi_id: @user_efi.efi_id)
      event2 = FactoryGirl.create(:event)

      @user_efi.events.should eq [event1]
    end
  end

  describe 'full_name' do
    it "deberia mostrar el nombre completo sin espacios en los extremos" do
      @user_efi = FactoryGirl.create(:user_efi, names: 'names_mas_espacio ')

      @user_efi.full_name.should eq (@user_efi.names.strip + ' ' + @user_efi.first_lastname.strip + ' ' + @user_efi.second_lastname.strip).strip
    end
  end
end
