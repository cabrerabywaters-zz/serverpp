require "spec_helper"

describe Corporative::PurchasesController do
  describe "routing" do

    it "routes to #show" do
      get("empresa/efi_search_name/purchases/1").should route_to("corporative/purchases#show", :id => '1', :corporative_id => 'efi_search_name')
    end

    it "routes to #new" do
      get("empresa/efi_search_name/events/1/purchases/new").should route_to("corporative/purchases#new", :id => '1', :corporative_id => 'efi_search_name')
    end

    it "routes to #post" do
      post("empresa/efi_search_name/events/1/purchases").should route_to("corporative/purchases#create", :id => '1', :corporative_id => 'efi_search_name')
    end

  end
end
