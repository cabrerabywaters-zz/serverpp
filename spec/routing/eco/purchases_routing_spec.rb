require "spec_helper"

describe Eco::PurchasesController do
  describe "routing" do

    it "routes to #index" do
      get("/eco/experiences/1/purchases").should route_to("eco/purchases#index", :id => "1")
    end

    it "routes to #validate" do
      post("/eco/experiences/1/purchases/validate").should route_to("eco/purchases#validate", :id => "1")
    end

  end
end
