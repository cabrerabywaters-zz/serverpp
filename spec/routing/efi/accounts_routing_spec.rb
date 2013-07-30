require "spec_helper"

describe Efi::AccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/accounts").should route_to("efi/accounts#index")
    end

    it "routes to #new" do
      get("/efi/accounts/new").should route_to("efi/accounts#new")
    end

    it "routes to #show" do
      get("/efi/accounts/1").should route_to("efi/accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/efi/accounts/1/edit").should route_to("efi/accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/efi/accounts").should route_to("efi/accounts#create")
    end

    it "routes to #update" do
      put("/efi/accounts/1").should route_to("efi/accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/efi/accounts/1").should route_to("efi/accounts#destroy", :id => "1")
    end

  end
end
