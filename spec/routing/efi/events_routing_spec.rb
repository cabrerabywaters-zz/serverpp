require "spec_helper"

describe Efi::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("/efi/events").should route_to("efi/events#index")
    end

    it "routes to #show" do
      get("/efi/events/1").should route_to("efi/events#show", :id => '1')
    end

    it "routes to #create" do
      post("/efi/experiences/1/events").should route_to("efi/events#create", :experience_id => "1")
    end





    it "routes to #publish" do
      put("/efi/events/1/publish").should route_to("efi/events#publish", :id => "1")
    end

    it "routes to #unpublish" do
      put("/efi/events/1/unpublish").should route_to("efi/events#unpublish", :id => "1")
    end

  end
end
