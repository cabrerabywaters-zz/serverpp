require "spec_helper"

describe PuntosPoint::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/events").should route_to("puntos_point/events#index")
    end



    it "routes to #bill" do
      put("/puntos_point/events/1/bill").should route_to("puntos_point/events#bill", :id => "1")
    end

    it "routes to #pay" do
      put("/puntos_point/events/1/pay").should route_to("puntos_point/events#pay", :id => "1")
    end

  end
end
