# encoding: utf-8
require 'spec_helper'

describe BaseConnector do
  ##############
  # attributes #
  ##############
  it "debe responder a efi_id" do
    should respond_to :efi_id
  end
  it "debe responder a rut" do
    should respond_to :rut
  end
  it "debe responder a password" do
    should respond_to :password
  end
  it "debe responder a points" do
    should respond_to :points
  end

  it "debe responder a identifier_value" do
    should respond_to :identifier_value
  end
  it "debe responder a identifier_name" do
    should respond_to :identifier_name
  end

  ################
  # associations #
  ################

  ###############
  # validations #
  ###############

  ###########
  # methods #
  ###########
  describe "get_points" do
    it "deberia responder a get_points" do
      should respond_to :get_points
    end
    it "deberia responder con los punto asociados a un rut" do
      account = FactoryGirl.create(:account, points: 100)
      efi     = account.efi

      efi.get_connector(rut: account.rut).get_points.should eq account.points
    end
    it "deberia responder nil si el rut es de otra compañia o no existe" do
      account = FactoryGirl.create(:account)
      efi     = FactoryGirl.create(:efi)

      efi.get_connector(rut: account.rut).get_points.should be_nil
    end
  end

  describe "get_points" do
    it "deberia responder a spend_points" do
      should respond_to :spend_points
    end
    it "deberia crear la transaction y responder 'true'" do
      efi     = FactoryGirl.create(:efi)
      account = FactoryGirl.create(:account, points: 100, efi_id: efi.id)
      efi.get_connector(rut: account.rut, password: account.password, points: 100).spend_points.should be_true
    end
    it "no deberia crear la transaction y responder 'false'" do
      efi     = FactoryGirl.create(:efi)
      account = FactoryGirl.create(:account, points: 100, efi_id: efi.id)
      efi.get_connector(rut: account.rut, password: account.password, points: 200).spend_points.should be_false
    end
    it "deberia responder nil si el rut es de otra compañia" do
      account = FactoryGirl.create(:account)
      efi     = FactoryGirl.create(:efi)

      efi.get_connector(rut: account.rut).get_points.should be_nil
    end
    it "deberia responder nil si el rut no existe" do
      efi     = FactoryGirl.create(:efi)

      efi.get_connector(rut: Run.generate).get_points.should be_nil
    end
  end
end
