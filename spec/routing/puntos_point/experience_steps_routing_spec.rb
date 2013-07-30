require "spec_helper"

describe PuntosPoint::ExperienceStepsController do
  describe "routing" do

    it "routes to #index" do
      # LIKE new
      get("/puntos_point/experience_steps").should route_to("puntos_point/experience_steps#index")

      # LIKE edit
      get("/puntos_point/experience_steps?experience_id=1").should route_to("puntos_point/experience_steps#index")
    end

    it "routes to #show" do
      get("/puntos_point/experience_steps/step1").should route_to("puntos_point/experience_steps#show", :id => "step1")

      get("/puntos_point/experience_steps/step2").should route_to("puntos_point/experience_steps#show", :id => "step2")

      get("/puntos_point/experience_steps/step3").should route_to("puntos_point/experience_steps#show", :id => "step3")
    end

    it "routes to #update" do
      put("/puntos_point/experience_steps/1").should route_to("puntos_point/experience_steps#update", :id => "1")
    end

  end
end
