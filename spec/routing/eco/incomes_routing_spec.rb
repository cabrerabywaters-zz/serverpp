require "spec_helper"

describe Eco::IncomesController do
  describe "routing" do

    it "routes to #index" do
      get("/eco/incomes").should route_to("eco/incomes#index")
    end

  end
end
