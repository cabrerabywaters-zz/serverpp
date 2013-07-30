require "spec_helper"

describe Efi::SummaryController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/summary").should route_to("efi/summary#index")
    end

  end
end
