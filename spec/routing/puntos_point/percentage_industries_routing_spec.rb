require "spec_helper"

describe PuntosPoint::PercentageIndustriesController do
  describe "routing" do

    it "routes to #edit" do
      get("/puntos_point/edit_percentage_industries/").should route_to("puntos_point/percentage_industries#edit")
    end

    it "routes to #update" do
      put("/puntos_point/percentage_industries/").should route_to("puntos_point/percentage_industries#update")
    end

  end
end
