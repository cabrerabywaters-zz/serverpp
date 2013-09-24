# encoding: utf-8
require 'spec_helper'

describe Eco::ExperiencesController do
  login_user_eco

  before :each do
    @eco         = @current_user_eco.eco
    @experience  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'draft')
  end

  describe "GET index" do
    it "assigns all experiences as @experiences" do
      get :index
      assigns(:experiences).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :index
      }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "GET show" do
    it "assigns the requested experience as @experience" do
      get :show, id: @experience
      assigns(:experience).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    it "assigns the purchases for requested experience as @purchases" do
      get :show, id: @experience
      assigns(:purchases).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :show, id: @experience
      }.to raise_error(CanCan::AccessDenied)
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
      response.should redirect_to(eco_experiences_url)
    end

    context "cuando la experience no esta pendiente" do
      it "debe redirigir a lista de experiences" do
        delete :destroy, id: @experience
        response.should redirect_to(eco_experiences_path)
      end

      it "no debe eliminar la experience" do
        experience2 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
        expect {
          delete :destroy, id: experience2
        }.to change(Experience, :count).by(0)
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        delete :destroy, id: @experience
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
