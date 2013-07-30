require 'spec_helper'

# ChileanCities::Comuna records MUST have been created to find them by name

describe PuntosPoint::ExperiencesController do
  login_admin

  before :each do
    @experience = FactoryGirl.create(:experience)
  end

  describe "GET index" do
    it "assigns all experiences as @experiences" do
      get :index
      assigns(:experiences).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested experience as @experience" do
      get :show, id: @experience
      assigns(:experience).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "PUT bill" do
    context "cuando la experience esta :expired" do
      it "debe actualizar el estado de la experience solicitada" do
        experience = FactoryGirl.create(:experience, state: 'expired')
        put :bill, id: experience
        assigns(:experience).billed?.should be_true
        response.should redirect_to(puntos_point_experiences_path)
      end
    end

    context "cuando la experience no esta :expired" do
      it "no debe actualizar el estado de la experience solicitada" do
        ['pending', 'published', 'on_sale', 'closed', 'billed', 'paid'].each do |state|
          experience = FactoryGirl.create(:experience, state: state)
          experience.expired?.should_not be_true
          put :bill, id: experience
          flash[:notice].should_not be_nil
          response.should redirect_to(puntos_point_experiences_path)
        end
      end
    end
  end

  describe "PUT pay" do
    context "cuando la experience esta billed" do
      it "updates the requested experience" do
        experience = FactoryGirl.create(:experience, state: 'billed')
        experience.billed?.should be_true
        put :pay, id: experience
        assigns(:experience).paid?.should be_true
        response.should redirect_to(puntos_point_experiences_path)
      end
    end

    context "cuando la experience no esta published" do
      it "updates the requested experience" do
        ['pending', 'published', 'on_sale', 'closed', 'expired', 'paid'].each do |state|
          experience = FactoryGirl.create(:experience, state: state)
          experience.billed?.should_not be_true
          put :pay, id: experience
          flash[:notice].should_not be_nil
          response.should redirect_to(puntos_point_experiences_path)
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested experience" do
      expect {
        delete :destroy, id: @experience
      }.to change(Experience, :count).by(-1)
    end

    it "redirects to the experiences list" do
      delete :destroy, id: @experience
      response.should redirect_to(puntos_point_experiences_url)
    end
  end

end
