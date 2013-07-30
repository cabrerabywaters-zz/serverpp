require "spec_helper"

describe Eco::PublicitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/eco/publicities").should route_to("eco/publicities#index")
    end

    it "routes to #show" do
      get("/eco/publicities/1").should route_to("eco/publicities#show", :id => "1")
    end

    it "routes to #accept" do
      put("/eco/publicities/1/accept").should route_to("eco/publicities#accept", :id => "1")
    end

    it "routes to #reject" do
      put("/eco/publicities/1/reject").should route_to("eco/publicities#reject", :id => "1")
    end

  end
end
