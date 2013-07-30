require 'spec_helper'

describe Exclusivity do
  ##############
  # attributes #
  ##############
  it "debe responder a id" do
    should respond_to :id
  end
  it "debe responder a name" do
    should respond_to :name
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
      Exclusivity.should respond_to :ids
    end
    it "deberia responder a find" do
      Exclusivity.should respond_to :find
    end

    context "para obtener de forma exacta el id de una exclusividad" do
      it "deberia responder a total_id" do
        Exclusivity.should respond_to :total_id
      end
      it "deberia responder a by_industry_id" do
        Exclusivity.should respond_to :by_industry_id
      end
      it "deberia responder a without_id" do
        Exclusivity.should respond_to :without_id
      end
    end
  end
end
