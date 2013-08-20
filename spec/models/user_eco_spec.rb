# encoding: utf-8
require 'spec_helper'

describe UserEco do
  ##############
  # attributes #
  ##############
  describe "attributes" do
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

    it "debe responder a eco_id" do
      should respond_to :eco_id
    end

    it "debe responder a group" do
      should respond_to :group
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe pertenecer a eco" do
      should belong_to(:eco)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:user_eco).should be_valid
  end

  describe ":group validations" do
    # Groups es una asociacion que agrega Burlesque al modelo
    # Mas información en: http://rubygems.org/gems/burlesque

    it "debe requerir un group" do
      user_eco = FactoryGirl.build(:user_eco)
      user_eco.group_ids = [] # Le indico al usuario que no tiene ningun grupo asignado
      user_eco.groups.should be_empty
      user_eco.should_not be_valid
    end

    context "cuando se crea" do
      it "no debe setear un grupo que no corresponda" do
        good_group = FactoryGirl.create(:burlesque_group)
        user_eco = FactoryGirl.build(:user_eco)
        user_eco.group_ids = [] # Le indico al usuario que no tiene ningun grupo asignado
        user_eco.group = good_group.id
        user_eco.should_not be_valid
      end
    end

    context "cuando se actualiza" do
      it "no debe setear un grupo que no corresponda" do
        user_eco   = FactoryGirl.create(:user_eco)
        good_group = FactoryGirl.create(:burlesque_group)
        user_eco.group = good_group
        user_eco.groups.should_not include(good_group)
        user_eco.should be_valid
      end
    end
  end

  it "debe requerir un first_lastname" do
    FactoryGirl.build(:user_eco, first_lastname: nil).should_not be_valid
    FactoryGirl.build(:user_eco, first_lastname: '').should_not be_valid
  end

  it "debe requerir un names" do
    FactoryGirl.build(:user_eco, names: nil).should_not be_valid
    FactoryGirl.build(:user_eco, names: '').should_not be_valid
  end

  it "debe requerir un id de eco" do
    FactoryGirl.build(:user_eco, eco_id: nil).should_not be_valid
    FactoryGirl.build(:user_eco, eco_id: '').should_not  be_valid
  end

  it "debe requerir un nickname" do
    FactoryGirl.build(:user_eco, nickname: nil).should_not be_valid
    FactoryGirl.build(:user_eco, nickname: '').should_not be_valid
  end

  it "debe requerir un nickname único" do
    FactoryGirl.create(:user_eco, nickname: 'alfa')
    FactoryGirl.build(:user_eco,  nickname: 'alfa').should_not be_valid
  end

  it "debe requerir un rut" do
    FactoryGirl.build(:user_eco, rut: nil).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '').should_not  be_valid
  end

  it "debe requerir un rut único" do
    FactoryGirl.create(:user_eco, rut: '11.111.111-1')
    FactoryGirl.build(:user_eco,  rut: '11.111.111-1').should_not be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:user_eco, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:user_eco, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:user_eco, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:user_eco, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:user_eco, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:user_eco, rut: Run.for(:user_eco, :rut)).should be_valid
  end

  ###########
  # methods #
  ###########
  describe 'methods' do
    it "debe responder a eco_name" do
      should respond_to :eco_name
    end
    it "debe responder a eco_fancy_name" do
      should respond_to :eco_fancy_name
    end

    it "debe responder a eco_logo" do
      should respond_to :eco_logo
    end

    describe 'full_name' do
      it "deberia mostrar el nombre completo sin espacios en los extremos" do
        user_eco = FactoryGirl.create(:user_eco, names: 'names_mas_espacio ')

        user_eco.full_name.should eq (user_eco.names.strip + ' ' + user_eco.first_lastname.strip + ' ' + user_eco.second_lastname.strip).strip
      end
    end

    it "debe aceptar attributos nesteados para :eco" do
      should accept_nested_attributes_for :eco
    end

    it "debe responder a experiences" do
      should respond_to :experiences
    end

    it "debe responder a eco_bigger?" do
      should respond_to :eco_bigger?
    end
  end
end
