# encoding: utf-8
require 'spec_helper'

describe Account do
  ##############
  # attributes #
  ##############
  it "debe responder a efi_id" do
    should respond_to :efi_id
  end

  it "debe responder a name" do
    should respond_to :name
  end

  it "debe responder a rut" do
    should respond_to :rut
  end

  it "debe responder a points" do
    should respond_to :points
  end

  it "debe responder a password" do
    should respond_to :password
  end

  ################
  # associations #
  ################
  it "debe pertenecer a efi" do
    should belong_to(:efi)
  end

  it "debe tener muchos transactions" do
    should have_many(:transactions).dependent(:destroy)
  end

  it "debe aceptar attributos para transactions" do
    should accept_nested_attributes_for :transactions
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:account).should be_valid
  end

  it "debe requerir un points" do
    FactoryGirl.build(:account, points: nil).should_not be_valid
    FactoryGirl.build(:account, points: '').should_not be_valid
  end

  it "debe requerir un name" do
    FactoryGirl.build(:account, name: nil).should_not be_valid
    FactoryGirl.build(:account, name: '').should_not be_valid
  end

  it "debe requerir un efi_id" do
    FactoryGirl.build(:account, efi_id: nil).should_not be_valid
    FactoryGirl.build(:account, efi_id: '').should_not be_valid
  end

  it "debe requerir un password" do
    FactoryGirl.build(:account, password: nil).should_not be_valid
    FactoryGirl.build(:account, password: '').should_not be_valid
  end

  it "debe requerir un points numerico" do
    should validate_numericality_of :points
    FactoryGirl.build(:account, points: 'a').should_not be_valid
  end

  it "debe requerir un points mayor a 0" do
    FactoryGirl.build(:account, points: '-1').should_not be_valid
    FactoryGirl.build(:account, points: -1).should_not   be_valid
    FactoryGirl.build(:account, points: '1.1').should_not be_valid
    FactoryGirl.build(:account, points: 1.1).should_not   be_valid
    FactoryGirl.build(:account, points: '-1.1').should_not be_valid
    FactoryGirl.build(:account, points: -1.1).should_not   be_valid

    FactoryGirl.build(:account, points: '0').should  be_valid
    FactoryGirl.build(:account, points: 0).should    be_valid
    FactoryGirl.build(:account, points: '1').should  be_valid
    FactoryGirl.build(:account, points: 1).should    be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:account, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:account, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:account, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:account, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:account, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:account, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:account, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:account, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:account, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:account, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:account, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:account, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:account, rut: Run.for(:account, :rut)).should be_valid
  end

  it "debe validar de forma única la combinación rut y efi_id" do
    efi    = FactoryGirl.create(:efi)

    FactoryGirl.create(:account, rut: '111111111', efi_id: efi.id)
    FactoryGirl.build(:account,  rut: '111111111', efi_id: efi.id).should_not be_valid
  end

  ###########
  # methods #
  ###########
  describe "balance" do
    context "por medio de la relacion :transactions" do
      it "deberia sumar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        account.transactions.create(points: 1, operation_id: 2) # Agrego puntos
        account.transactions.create(points: 2, operation_id: 4) # Agrego puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(13)
      end
      it "deberia restar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        account.transactions.create(points: 1, operation_id: 3) # Quito puntos
        account.transactions.create(points: 2, operation_id: 5) # Quito puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(7)
      end
      it "deberia setear puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        account.transactions.create(points: 9, operation_id: 1) # Setear los puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(9)
      end
    end
    context "por medio de la clase Transaction usando el id de la Account" do
      it "deberia sumar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 1, operation_id: 2, account_id: account.id) # Agrego puntos
        Transaction.create(points: 2, operation_id: 4, account_id: account.id) # Agrego puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(13)
      end
      it "deberia restar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 1, operation_id: 3, account_id: account.id) # Quito puntos
        Transaction.create(points: 2, operation_id: 5, account_id: account.id) # Quito puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(7)
      end
      it "deberia setear puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 9, operation_id: 1, account_id: account.id) # Setear los puntos
        account.reload # TODO - revisar porque se debe recargar en estos casos
        account.points.should eq(9)
      end
    end
    context "por medio de la clase Transaction usando la instancia de la Account" do
      it "deberia sumar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 1, operation_id: 2, account: account) # Agrego puntos
        Transaction.create(points: 2, operation_id: 4, account: account) # Agrego puntos
        account.points.should eq(13)
      end
      it "deberia restar puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 1, operation_id: 3, account: account) # Quito puntos
        Transaction.create(points: 2, operation_id: 5, account: account) # Quito puntos
        account.points.should eq(7)
      end
      it "deberia setear puntos de la nueva transaccion" do
        account = FactoryGirl.create(:account, points: 10)
        Transaction.create(points: 9, operation_id: 1, account: account) # Setear los puntos
        account.points.should eq(9)
      end
    end
  end
end
