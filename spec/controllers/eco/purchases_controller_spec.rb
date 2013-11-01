# encoding: utf-8
require 'spec_helper'

describe Eco::PurchasesController do
  login_user_eco

  before :each do
    @eco         = @current_user_eco.eco

    @experience  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'active')
    @experience2 = FactoryGirl.create(:experience, state: 'published')
    experience3  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'active')
    @experience4 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'expired')
    @experience5 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
    @experience6 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'draft')
    @experience7 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'closed')

    event        = FactoryGirl.create(:event, experience_id: @experience.id)
    event3       = FactoryGirl.create(:event, experience_id: experience3.id)
    exchange     = event.exchanges.last
    @purchase1   = FactoryGirl.create(:purchase, exchange_id: exchange.id, state: 'sold')
    @purchase2   = FactoryGirl.create(:purchase, exchange_id: exchange.id, state: 'validated')
    @purchase3   = FactoryGirl.create(:purchase, state: 'sold')
    @purchase4   = FactoryGirl.create(:purchase, exchange_id: event3.exchanges.last.id, state: 'sold')
  end

  describe "GET index" do
    context "cuando la experience esta en venta" do
      it "assigns experience as @experience" do
        get :index, id: @experience
        assigns(:experience).should_not be_nil
        response.should be_success
        response.should render_template("index")
      end
    end
    context "cuando la experience esta publicada" do
      it "assigns experience as @experience" do
        get :index, id: @experience5
        assigns(:experience).should_not be_nil
        response.should be_success
        response.should render_template("index")
      end
    end

    # context "cuando la experience esta pending" do
    #   it "assigns experience as @experience" do
    #     get :index, id: @experience6
    #     assigns(:experience).should_not be_nil
    #     response.should be_success
    #     response.should render_template("index")
    #   end
    # end

    context "cuando la experience esta closed" do
      it "assigns experience as @experience" do
        get :index, id: @experience7
        assigns(:experience).should_not be_nil
        response.should be_success
        response.should render_template("index")
      end
    end

    it "assigns purchases for requested experience as @purchases" do
      get :index, id: @experience
      assigns(:purchases).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "debe asignar solo las purchases validadas y asociadas a la experience" do
      get :index, id: @experience
      assigns(:purchases).should eq([@purchase2])
      response.should be_success
      response.should render_template("index")
    end

    it "no debe poder acceder a una experience que despues que expiro" do
      expect {
        post :validate, id: @experience4, code: ''
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :index, id: @experience
      }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "POST validate" do
    describe "with valid params" do
      it "updates the requested purchase with validate! method" do
        Purchase.any_instance.should_receive(:validate!).and_return(true)
        post :validate, id: @experience, code: @purchase1.code
      end

      it "assigns the requested purchase as @purchase" do
        post :validate, id: @experience, code: @purchase1.code
        assigns(:purchase).should eq(@purchase1)
      end

      it "redirects to the experience" do
        post :validate, id: @experience, code: @purchase1.code
        response.should redirect_to(eco_experience_purchases_path(@experience))
      end

      it "debe setear un mensaje de feedback" do
        post :validate, id: @experience, code: @purchase1.code
        flash[:notice].should_not be_nil
      end
    end

    describe "with invalid params" do
      it "no debe hacer nada si el codigo no existe" do
        post :validate, id: @experience, code: 'este_codigo_no_es_valido'
        assigns(:purchase).should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(eco_experience_purchases_path(@experience))
      end

      it "no debe actualizar la purchase" do
        Purchase.any_instance.should_receive(:validated?).and_return(true)
        post :validate, id: @experience, code: @purchase2.code
        flash[:notice].should_not be_nil
        response.should redirect_to(eco_experience_purchases_path(@experience))
      end

      it "no debe acceder a la purchase si no es de la eco del usuario logeado" do
        post :validate, id: @experience, code: @purchase3.code
        assigns(:purchase).should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(eco_experience_purchases_path(@experience))
      end

      it "no debe acceder a la purchase si es de otra experience" do
        post :validate, id: @experience, code: @purchase4.code
        assigns(:purchase).should be_nil
        flash[:notice].should_not be_nil
        response.should redirect_to(eco_experience_purchases_path(@experience))
      end

      it "debe generar un error al no encontrar la experience" do
        expect {
          post :validate, id: 0, code: @purchase1.code
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "no debe poder encontrar experiences de otras eco" do
        expect {
          post :validate, id: @experience2, code: @purchase1.code
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "no debe poder acceder a una experience que despues que expiro" do
        expect {
          post :validate, id: @experience4, code: ''
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        post :validate, id: @experience, code: @purchase1.code
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
