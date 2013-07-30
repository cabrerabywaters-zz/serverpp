# encoding: utf-8
require 'spec_helper'

describe Eco::PublicitiesController do
  login_user_eco

  before :each do
    @eco        = @current_user_eco.eco

    experience  = FactoryGirl.create(:experience, eco_id: @eco.id)
    @event       = FactoryGirl.create(:event, experience_id: experience.id)

    @publicity  = FactoryGirl.create(:publicity, event_id: @event.id)
    @publicity2 = FactoryGirl.create(:publicity)

    @valid_attributes = { 'coment' => 'Lorem ipsum' }
  end

  describe "GET index" do
    it "assigns all publicity as @publicities" do
      get :index
      assigns(:publicities).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los publicities de la Eco del usuario logeado" do
      get :index
      assigns(:publicities).should eq [@publicity]
      response.should be_success
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
    it "assigns the requested publicity as @publicity" do
      get :show, id: @publicity
      assigns(:publicity).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "cuando la publicity no es de la Eco del usuario logeado" do
      it "no debe mostrar la publicity" do
        expect{
          get :show, id: @publicity2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :show, id: @publicity
      }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "PUT accept" do
    context "cuando la :publicity esta :pending" do
      it "debe actualizar el estado de la :publicity solicitada con comentario" do
        put :accept, id: @publicity, publicity: {comment: 'Lorem ipsum'}
        assigns(:publicity).accepted?.should be_true
        response.should redirect_to(eco_publicity_path(@publicity))
      end

      it "debe actualizar el estado de la :publicity solicitada sin comentario" do
        put :accept, id: @publicity, publicity: {comment: ''}
        assigns(:publicity).accepted?.should be_true
        response.should redirect_to(eco_publicity_path(@publicity))
      end
    end

    context "cuando la :publicity no esta :pending" do
      it "no debe actualizar el estado de la :publicity solicitada" do
        ['accepted', 'rejected'].each do |state|
          publicity = FactoryGirl.create(:publicity, event_id: @event.id, state: state)
          publicity.pending?.should_not be_true
          put :accept, id: publicity, publicity: {comment: 'Lorem ipsum'}
          flash[:notice].should_not be_nil
          response.should redirect_to(eco_publicity_path(publicity))
        end
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        put :accept, id: @publicity, publicity: {comment: 'Lorem ipsum'}
      }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "PUT reject" do
    context "cuando la :publicity esta :pending" do
      it "debe actualizar el estado de la :publicity solicitada con comentario" do
        put :reject, id: @publicity, publicity: {comment: 'Lorem ipsum'}
        assigns(:publicity).rejected?.should be_true
        response.should redirect_to(eco_publicity_path(@publicity))
      end

      it "no debe actualizar el estado de la :publicity solicitada sin comentario" do
        put :reject, id: @publicity, publicity: {comment: ''}
        assigns(:publicity).rejected?.should be_false
        response.should render_template("show")
      end
    end

    context "cuando la :publicity no esta :pending" do
      it "no debe actualizar el estado de la :publicity solicitada" do
        ['accepted', 'rejected'].each do |state|
          publicity = FactoryGirl.create(:publicity, event_id: @event.id, state: state)
          publicity.pending?.should_not be_true
          put :reject, id: publicity, publicity: {comment: 'Lorem ipsum'}
          flash[:notice].should_not be_nil
          response.should redirect_to(eco_publicity_path(publicity))
        end
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        put :reject, id: @publicity, publicity: {comment: 'Lorem ipsum'}
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
