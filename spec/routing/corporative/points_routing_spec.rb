require "spec_helper"

describe Corporative::PointsController do
  describe "routing" do

    it "routes to #create" do
      post("empresa/efi_search_name/points.js").should route_to("corporative/points#create", :corporative_id => 'efi_search_name', :format => 'js')
    end

  end
end
