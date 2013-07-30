require "spec_helper"

describe Efi::TradesController do
  describe "routing" do

    it "routes to #category" do
      get("/efi/trades/category").should route_to("efi/trades#category")
    end

    it "routes to #efi" do
      get("/efi/trades/efi").should route_to("efi/trades#efi")
    end

  end
end
