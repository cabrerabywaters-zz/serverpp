require "spec_helper"

describe Efi::ExperiencesController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/experiences").should route_to("efi/experiences#index")
    end

    it "routes to #show" do
      get("/efi/experiences/1").should route_to("efi/experiences#show", :id => "1")
    end

  end
end
