require "spec_helper"

describe Efi::BannersController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/banners").should route_to("efi/banners#index")
    end

    it "routes to #new" do
      get("/efi/banners/new").should route_to("efi/banners#new")
    end

    it "routes to #show" do
      get("/efi/banners/1").should route_to("efi/banners#show", :id => "1")
    end

    it "routes to #edit" do
      get("/efi/banners/1/edit").should route_to("efi/banners#edit", :id => "1")
    end

    it "routes to #create" do
      post("/efi/banners").should route_to("efi/banners#create")
    end

    it "routes to #update" do
      put("/efi/banners/1").should route_to("efi/banners#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/efi/banners/1").should route_to("efi/banners#destroy", :id => "1")
    end

  end
end
