require 'spec_helper'

describe PuntosPoint::EventsController do
  login_admin

  before :each do
    @event = FactoryGirl.create(:event)
  end

  describe "GET index" do
    it "assigns all events as @events" do
      get :index
      assigns(:events).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "PUT bill" do
    context "cuando el event esta :closed" do
      it "updates the requested event" do
        event = FactoryGirl.create(:event, state: 'closed')
        put :bill, id: event
        assigns(:event).billed?.should be_true
        response.should redirect_to(puntos_point_events_path)
      end
    end

    context "cuando el event no esta :closed" do
      it "can't updates the requested event" do
        ['taken', 'billed', 'paid'].each do |state|
          event = FactoryGirl.create(:event, state: state)
          event.closed?.should_not be_true
          put :bill, id: event
          flash[:notice].should_not be_nil
          response.should redirect_to(puntos_point_events_path)
        end
      end
    end
  end

  describe "PUT pay" do
    context "cuando el event esta :billed" do
      it "updates the requested event" do
        event = FactoryGirl.create(:event, state: 'billed')
        event.billed?.should be_true
        put :pay, id: event
        assigns(:event).paid?.should be_true
        response.should redirect_to(puntos_point_events_path)
      end
    end

    context "cuando el event no esta published" do
      it "can't updates the requested event" do
        ['taken', 'closed', 'paid'].each do |state|
          event = FactoryGirl.create(:event, state: state)
          event.billed?.should_not be_true
          put :pay, id: event
          flash[:notice].should_not be_nil
          response.should redirect_to(puntos_point_events_path)
        end
      end
    end
  end

end
