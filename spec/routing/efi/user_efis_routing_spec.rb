require "spec_helper"

describe Efi::UserEfisController do
  describe "routing" do

    it "routes to #edit" do
      get("/efi/user_efis/1/edit").should route_to("efi/user_efis#edit", :id => "1")
    end

    it "routes to #update" do
      put("/efi/user_efis/1").should route_to("efi/user_efis#update", :id => "1")
    end

  end
end
