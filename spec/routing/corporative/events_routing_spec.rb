require "spec_helper"

describe Corporative::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("empresa/efi_search_name").should route_to("corporative/events#index", :corporative_id => 'efi_search_name')
    end

    it "routes to #show" do
      get("empresa/efi_search_name/events/1").should route_to("corporative/events#show", :id => "1", :corporative_id => 'efi_search_name')
    end

  end
end
