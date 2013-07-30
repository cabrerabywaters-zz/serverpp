require "spec_helper"

describe Efi::UserEfisController do
  describe "routing" do

    it "routes to #edit" do
      get("/eco/user_ecos/1/edit").should route_to("eco/user_ecos#edit", :id => "1")
    end

    it "routes to #update" do
      put("/eco/user_ecos/1").should route_to("eco/user_ecos#update", :id => "1")
    end

  end
end
