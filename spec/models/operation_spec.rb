require 'spec_helper'

describe Operation do
  ##############
  # attributes #
  ##############
  it "debe responder a id" do
    should respond_to :id
  end
  it "debe responder a name" do
    should respond_to :name
  end
  it "debe responder a mechanism" do
    should respond_to :mechanism
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
  describe 'ClassMethods' do
    it "deberia responder a ids" do
      Operation.should respond_to :ids
    end
    it "deberia responder a find" do
      Operation.should respond_to :find
    end
    it "deberia responder a all" do
      Operation.should respond_to :all
    end
    it "deberia responder a expend_id" do
      Operation.should respond_to :expend_id
    end
  end
end
