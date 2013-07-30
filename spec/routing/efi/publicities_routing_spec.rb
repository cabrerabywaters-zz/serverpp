require "spec_helper"

describe Efi::PublicitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/publicities").should route_to("efi/publicities#index")
    end

    it "routes to #new" do
      get("/efi/publicities/new").should route_to("efi/publicities#new")
    end

    it "routes to #show" do
      get("/efi/publicities/1").should route_to("efi/publicities#show", :id => "1")
    end

    it "routes to #create" do
      post("/efi/publicities").should route_to("efi/publicities#create")
    end

    it "routes to #destroy" do
      delete("/efi/publicities/1").should route_to("efi/publicities#destroy", :id => "1")
    end

  end
end
