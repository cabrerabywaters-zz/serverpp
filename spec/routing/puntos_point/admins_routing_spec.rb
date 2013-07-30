require "spec_helper"

describe PuntosPoint::AdminsController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/admins").should route_to("puntos_point/admins#index")
    end

    it "routes to #new" do
      get("/puntos_point/admins/new").should route_to("puntos_point/admins#new")
    end

    it "routes to #show" do
      get("/puntos_point/admins/1").should route_to("puntos_point/admins#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/admins/1/edit").should route_to("puntos_point/admins#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/admins").should route_to("puntos_point/admins#create")
    end

    it "routes to #update" do
      put("/puntos_point/admins/1").should route_to("puntos_point/admins#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/admins/1").should route_to("puntos_point/admins#destroy", :id => "1")
    end

  end
end
