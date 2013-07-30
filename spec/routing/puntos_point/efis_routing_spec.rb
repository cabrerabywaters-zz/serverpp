require "spec_helper"

describe PuntosPoint::EfisController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/efis").should route_to("puntos_point/efis#index")
    end

    it "routes to #new" do
      get("/puntos_point/efis/new").should route_to("puntos_point/efis#new")
    end

    it "routes to #show" do
      get("/puntos_point/efis/1").should route_to("puntos_point/efis#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/efis/1/edit").should route_to("puntos_point/efis#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/efis").should route_to("puntos_point/efis#create")
    end

    it "routes to #update" do
      put("/puntos_point/efis/1").should route_to("puntos_point/efis#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/efis/1").should route_to("puntos_point/efis#destroy", :id => "1")
    end

  end
end
