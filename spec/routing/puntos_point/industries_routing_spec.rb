require "spec_helper"

describe PuntosPoint::IndustriesController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/industries").should route_to("puntos_point/industries#index")
    end

    it "routes to #new" do
      get("/puntos_point/industries/new").should route_to("puntos_point/industries#new")
    end

    it "routes to #show" do
      get("/puntos_point/industries/1").should route_to("puntos_point/industries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/industries/1/edit").should route_to("puntos_point/industries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/industries").should route_to("puntos_point/industries#create")
    end

    it "routes to #update" do
      put("/puntos_point/industries/1").should route_to("puntos_point/industries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/industries/1").should route_to("puntos_point/industries#destroy", :id => "1")
    end

  end
end
