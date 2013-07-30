require "spec_helper"

describe PuntosPoint::SmallEcosController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/small_ecos").should route_to("puntos_point/small_ecos#index")
    end

    it "routes to #new" do
      get("/puntos_point/small_ecos/new").should route_to("puntos_point/small_ecos#new")
    end

    it "routes to #show" do
      get("/puntos_point/small_ecos/1").should route_to("puntos_point/small_ecos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/small_ecos/1/edit").should route_to("puntos_point/small_ecos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/small_ecos").should route_to("puntos_point/small_ecos#create")
    end

    it "routes to #update" do
      put("/puntos_point/small_ecos/1").should route_to("puntos_point/small_ecos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/small_ecos/1").should route_to("puntos_point/small_ecos#destroy", :id => "1")
    end

  end
end
