require "spec_helper"

describe PuntosPoint::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/puntos_point/categories").should route_to("puntos_point/categories#index")
    end

    it "routes to #new" do
      get("/puntos_point/categories/new").should route_to("puntos_point/categories#new")
    end

    it "routes to #show" do
      get("/puntos_point/categories/1").should route_to("puntos_point/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/puntos_point/categories/1/edit").should route_to("puntos_point/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/puntos_point/categories").should route_to("puntos_point/categories#create")
    end

    it "routes to #update" do
      put("/puntos_point/categories/1").should route_to("puntos_point/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/puntos_point/categories/1").should route_to("puntos_point/categories#destroy", :id => "1")
    end

  end
end
