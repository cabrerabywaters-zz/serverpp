require "spec_helper"

describe PuntosPoint::ExperiencesController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/experiences").should route_to("puntos_point/experiences#index")
    end

    it "routes to #show" do
      get("/puntos_point/experiences/1").should route_to("puntos_point/experiences#show", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/experiences/1").should route_to("puntos_point/experiences#destroy", :id => "1")
    end




    it "routes to #bill" do
      put("/puntos_point/experiences/1/bill").should route_to("puntos_point/experiences#bill", :id => "1")
    end

    it "routes to #pay" do
      put("/puntos_point/experiences/1/pay").should route_to("puntos_point/experiences#pay", :id => "1")
    end

  end
end
