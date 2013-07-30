require "spec_helper"

describe Eco::ExperiencesController do
  describe "routing" do

    it "routes to #index" do
      get("/eco/experiences").should route_to("eco/experiences#index")
    end

    it "routes to #show" do
      get("/eco/experiences/1").should route_to("eco/experiences#show", :id => "1")
    end

    it "routes to #destroy" do
      delete("/eco/experiences/1").should route_to("eco/experiences#destroy", :id => "1")
    end

  end
end
