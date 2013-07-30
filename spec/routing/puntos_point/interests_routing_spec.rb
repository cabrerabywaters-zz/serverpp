require "spec_helper"

describe PuntosPoint::InterestsController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/interests").should route_to("puntos_point/interests#index")
    end

    it "routes to #new" do
      get("/puntos_point/interests/new").should route_to("puntos_point/interests#new")
    end

    it "routes to #show" do
      get("/puntos_point/interests/1").should route_to("puntos_point/interests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/interests/1/edit").should route_to("puntos_point/interests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/interests").should route_to("puntos_point/interests#create")
    end

    it "routes to #update" do
      put("/puntos_point/interests/1").should route_to("puntos_point/interests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/interests/1").should route_to("puntos_point/interests#destroy", :id => "1")
    end

  end
end
