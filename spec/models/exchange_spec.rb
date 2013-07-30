# encoding: utf-8
require 'spec_helper'

describe Exchange do
  ##############
  # attributes #
  ##############
  it "debe responder a cash" do
    should respond_to :cash
  end

  it "debe responder a points" do
    should respond_to :points
  end

  it "debe responder a event_id" do
    should respond_to :event_id
  end

  ################
  # associations #
  ################
  it "debe pertenecer a event" do
    should belong_to(:event)
  end

  it "debe tener muchos purchases" do
    should have_many(:purchases).dependent(:destroy)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:exchange).should be_valid
  end

  it "debe requerir un points" do
    FactoryGirl.build(:exchange, points: nil).should_not be_valid
    FactoryGirl.build(:exchange, points: '').should_not be_valid
  end

  it "debe requerir un points numerico" do
    should validate_numericality_of :points
    FactoryGirl.build(:exchange, points: 'a').should_not be_valid
  end

  it "debe requerir un points mayor a 0" do
    FactoryGirl.build(:exchange, points: '-1').should_not be_valid
    FactoryGirl.build(:exchange, points: -1).should_not   be_valid
    FactoryGirl.build(:exchange, points: '0').should_not  be_valid
    FactoryGirl.build(:exchange, points: 0).should_not    be_valid

    FactoryGirl.build(:exchange, points: '1').should be_valid
    FactoryGirl.build(:exchange, points: 1).should   be_valid
  end

  context "al actualizar" do
    it "debe requerir un event_id" do
      event = FactoryGirl.create(:exchange)

      event.event_id = nil
      event.should_not be_valid

      event.event_id = ''
      event.should_not be_valid
    end
  end

  context "al crear" do
    it "debe requerir un event_id" do
      pending "TODO - no se implemento ya que al agregar la validación 'on create' no se puede crear un Event y asignarle Exchanges"
    end
  end

  context "si cash esta asignado" do
    it "debe ser requerido" do
      FactoryGirl.build(:exchange, cash: nil).should  be_valid
      FactoryGirl.build(:exchange, cash: '').should   be_valid
    end
    it "debe ser numerico" do
      FactoryGirl.build(:exchange, cash: 'a').should_not  be_valid
    end
    it "debe ser mayor o igual a cero" do
      FactoryGirl.build(:exchange, cash: '-1').should_not be_valid
      FactoryGirl.build(:exchange, cash: -1).should_not   be_valid

      FactoryGirl.build(:exchange, cash: '0').should  be_valid
      FactoryGirl.build(:exchange, cash: 0).should    be_valid
      FactoryGirl.build(:exchange, cash: '1').should  be_valid
      FactoryGirl.build(:exchange, cash: 1).should    be_valid
    end
  end

  ###########
  # methods #
  ###########
  describe "name" do
    it "deberia responder a name" do
      should respond_to :name
    end
  end
end
