# encoding: utf-8
require 'spec_helper'

describe Admin do
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

  ################
  # associations #
  ################
  describe "associations" do
    it "debe tener muchos ecos" do
      should have_many(:ecos).dependent(:nullify)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:admin).should be_valid
  end

  it "debe requerir un first_lastname" do
    FactoryGirl.build(:admin, first_lastname: nil).should_not be_valid
    FactoryGirl.build(:admin, first_lastname: '').should_not be_valid
  end

  it "debe requerir un names" do
    FactoryGirl.build(:admin, names: nil).should_not be_valid
    FactoryGirl.build(:admin, names: '').should_not be_valid
  end

  it "debe requerir un nickname" do
    FactoryGirl.build(:admin, nickname: nil).should_not be_valid
    FactoryGirl.build(:admin, nickname: '').should_not be_valid
  end

  it "debe requerir un nickname único" do
    FactoryGirl.create(:admin, nickname: 'alfa')
    FactoryGirl.build(:admin,  nickname: 'alfa').should_not be_valid
  end

  it "debe requerir un rut" do
    FactoryGirl.build(:admin, rut: nil).should_not be_valid
    FactoryGirl.build(:admin, rut: '').should_not  be_valid
  end

  it "debe requerir un rut único" do
    FactoryGirl.create(:admin, rut: '11.111.111-1')
    FactoryGirl.build(:admin,  rut: '11.111.111-1').should_not be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:admin, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:admin, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:admin, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:admin, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:admin, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:admin, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:admin, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:admin, rut: Run.for(:admin, :rut)).should be_valid
  end

  ###########
  # methods #
  ###########
  describe 'full_name' do
    it "deberia mostrar el nombre completo sin espacios en los extremos" do
      @admin = FactoryGirl.create(:admin, names: 'names_mas_espacio ')

      @admin.full_name.should eq (@admin.names.strip + ' ' + @admin.first_lastname.strip + ' ' + @admin.second_lastname.strip).strip
    end
  end
end
