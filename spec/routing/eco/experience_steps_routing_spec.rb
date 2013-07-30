require "spec_helper"

describe Eco::ExperienceStepsController do
  describe "routing" do

    it "routes to #index" do
      # LIKE new
      get("/eco/experience_steps").should route_to("eco/experience_steps#index")

      # LIKE edit
      get("/eco/experience_steps?experience_id=1").should route_to("eco/experience_steps#index")
    end

    it "routes to #show" do
      get("/eco/experience_steps/step1").should route_to("eco/experience_steps#show", :id => "step1")

      get("/eco/experience_steps/step2").should route_to("eco/experience_steps#show", :id => "step2")
    end

    it "routes to #update" do
      put("/eco/experience_steps/1").should route_to("eco/experience_steps#update", :id => "1")
    end

  end
end
