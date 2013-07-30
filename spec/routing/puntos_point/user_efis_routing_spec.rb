require "spec_helper"

describe PuntosPoint::UserEfisController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/user_efis").should route_to("puntos_point/user_efis#index")
    end

    it "routes to #new" do
      get("/puntos_point/user_efis/new").should route_to("puntos_point/user_efis#new")
    end

    it "routes to #show" do
      get("/puntos_point/user_efis/1").should route_to("puntos_point/user_efis#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/user_efis/1/edit").should route_to("puntos_point/user_efis#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/user_efis").should route_to("puntos_point/user_efis#create")
    end

    it "routes to #update" do
      put("/puntos_point/user_efis/1").should route_to("puntos_point/user_efis#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/user_efis/1").should route_to("puntos_point/user_efis#destroy", :id => "1")
    end

  end
end
