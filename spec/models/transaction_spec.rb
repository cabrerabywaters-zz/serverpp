# encoding: utf-8
require 'spec_helper'

describe Transaction do
  ##############
  # attributes #
  ##############
  it "debe responder a operation_id" do
    should respond_to :operation_id
  end

  it "debe responder a points" do
    should respond_to :points
  end

  it "debe responder a account_id" do
    should respond_to :account_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a account" do
    should belong_to(:account)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:transaction).should be_valid
  end

  it "debe requerir un operation_id" do
    FactoryGirl.build(:transaction, operation_id: nil).should_not be_valid
    FactoryGirl.build(:transaction, operation_id: '').should_not be_valid
  end

  it "debe requerir un points" do
    FactoryGirl.build(:transaction, points: nil).should_not be_valid
    FactoryGirl.build(:transaction, points: '').should_not be_valid
  end

  context "al actualizar" do
    it "debe requerir un account_id" do
      transaction = FactoryGirl.create(:transaction)

      transaction.account_id = nil
      transaction.should_not be_valid

      transaction.account_id = ''
      transaction.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un account_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear una Account y asignarle Transactions"
    end
  end

  it "debe requerir un operation_id valido" do
    FactoryGirl.build(:transaction, operation_id:  -1).should_not be_valid
    FactoryGirl.build(:transaction, operation_id:   0).should_not be_valid
    FactoryGirl.build(:transaction, operation_id: 100).should_not be_valid

    Operation.ids.each do |operation_id|
      FactoryGirl.build(:transaction, operation_id: operation_id).should be_valid
    end
  end

  it "debe validar la cantidad de puntos de la cuenta" do
    account = FactoryGirl.create(:account, points: 0)
    FactoryGirl.build(:transaction, operation_id: 1, account: account).should be_valid  # Setear los puntos
    FactoryGirl.build(:transaction, operation_id: 2, account: account).should be_valid  # Agrego puntos
    FactoryGirl.build(:transaction, operation_id: 3, account: account).should_not be_valid  # Quito puntos
    FactoryGirl.build(:transaction, operation_id: 4, account: account).should be_valid  # Agrego puntos
    FactoryGirl.build(:transaction, operation_id: 5, account: account).should_not be_valid  # Quito puntos
  end

  ###########
  # methods #
  ###########
  describe "operation" do
    it "debe responder a operation" do
      should respond_to :operation
    end
  end
end
