require "spec_helper"

describe PuntosPoint::SmallEcosController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/big_ecos").should route_to("puntos_point/big_ecos#index")
    end

    it "routes to #new" do
      get("/puntos_point/big_ecos/new").should route_to("puntos_point/big_ecos#new")
    end

    it "routes to #show" do
      get("/puntos_point/big_ecos/1").should route_to("puntos_point/big_ecos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/big_ecos/1/edit").should route_to("puntos_point/big_ecos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/big_ecos").should route_to("puntos_point/big_ecos#create")
    end

    it "routes to #update" do
      put("/puntos_point/big_ecos/1").should route_to("puntos_point/big_ecos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/big_ecos/1").should route_to("puntos_point/big_ecos#destroy", :id => "1")
    end

  end
end
