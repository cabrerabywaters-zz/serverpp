# encoding: utf-8
require 'spec_helper'

describe Corporative::PurchasesController do
  before :each do
    @purchase = FactoryGirl.create(:purchase)

    @event      = FactoryGirl.create(:event)
    @efi        = @event.efi
    @event2     = FactoryGirl.create(:event)
    @account    = FactoryGirl.create(:account, efi_id: @efi.id)
    @account2   = FactoryGirl.create(:account, efi_id: @efi.id, points: 0)

    @valid_attributes = {rut: @account.rut, password: @account.password, email: 'test@test.cl', exchange_id: @event.exchanges.last.id}

    @closed_event                   = FactoryGirl.create(:event, efi_id: @efi.id, state: 'closed')

    @future_event                   = FactoryGirl.create(:event, efi_id: @efi.id)
    experience                      = @future_event.experience
    experience.starting_at          = Date.current + 10.day
    experience.ending_at            = Date.current + 10.day
    experience.validity_starting_at = Date.current + 10.day
    experience.validity_ending_at   = Date.current + 10.day
    experience.save
  end

  describe "GET show" do
    it "assigns a requested purchase as @purchase" do
      get :show, id: @purchase, corporative_id: @efi.search_name
      assigns(:purchase).should_not be_a_nil
      assigns(:event).should_not be_a_nil
      assigns(:experience).should_not be_a_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new purchase as @purchase" do
      get :new, id: @event, corporative_id: @efi.search_name
      assigns(:purchase).should be_a_new(Purchase)
      response.should be_success
      response.should render_template("new")
    end

    it "assigns a requested event as @event" do
      get :new, id: @event, corporative_id: @efi.search_name
      assigns(:event).should_not be_nil
      response.should be_success
      response.should render_template("new")
    end

    it "assigns a event experience as @experience" do
      get :new, id: @event, corporative_id: @efi.search_name
      assigns(:experience).should_not be_nil
      response.should be_success
      response.should render_template("new")
    end

    context "cuando el Event no pertenece a la EFI" do
      it "no debe mostrar la experience" do
        get :new, id: @event2, corporative_id: @efi.search_name
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end
    end

    context "cuando el Event ya no esta disponible" do
      it "no deberia mostrar el event si aun no esta disponible segun rangos de fechas" do
        get :new, id: @future_event, corporative_id: @efi.search_name
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end

      it "no deberia mostrar el event si ya no esta disponible segun rangos de fechas" do
        get :new, id: @closed_event, corporative_id: @efi.search_name
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end

      it "no deberia mostrar el event si este no esta publicado" do
        event_taken  = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')

        get :new, id: event_taken, corporative_id: @efi.search_name
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Purchase" do
        expect {
          post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @event.id
        }.to change(Purchase, :count).by(1)
      end

      it "assigns a newly created purchase as @purchase" do
        post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @event.id
        assigns(:purchase).should be_a(Purchase)
      end

      it "redirects to the created purchase" do
        post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @event.id
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_purchase_path(@efi.search_name, assigns(:purchase).id))
      end

      it "deliver the voucher to email" do
        expect {
          post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @event.id
        }.to change(ActionMailer::Base.deliveries, :size).by(1)

        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.to.should include @valid_attributes[:email]
      end
    end

    describe "with invalid params" do
      it "sin rut" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes.delete(:rut)

        post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
        response.should render_template("new")
      end
      it "sin password" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes.delete(:password)

        post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
        response.should render_template("new")
      end
      it "sin email" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes.delete(:email)

        post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
        response.should render_template("new")
      end
      it "sin exchange_id" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes.delete(:exchange_id)

        post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
        response.should render_template("new")
      end

      context "cuando la cuenta no existe" do
        it "no debe guardar" do
          invalid_attributes = @valid_attributes.clone
          invalid_attributes[:rut] = Run.for(:account, :rut)

          post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
          response.should render_template("new")
        end
      end
      context "cuando el rut no es valido" do
        it "no debe guardar" do
          invalid_attributes = @valid_attributes.clone
          invalid_attributes[:rut] = '1-1'

          post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
          response.should render_template("new")
        end
      end
      context "cuando el rut y la contraseña no coinciden" do
        it "no debe guardar" do
          invalid_attributes = @valid_attributes.clone
          invalid_attributes[:password] = '87654321'

          post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
          response.should render_template("new")
        end
      end
    end

    context "cuando el Event ya no esta disponible" do
      it "no deberia mostrar el event si aun no esta disponible segun rangos de fechas" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes[:exchange_id] = @future_event.exchanges.last.id
        post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @future_event.id
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end

      it "no deberia mostrar el event si ya no esta disponible segun rangos de fechas" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes[:exchange_id] = @closed_event.exchanges.last.id
        post :create, purchase: @valid_attributes, corporative_id: @efi.search_name, id: @closed_event.id
        flash[:notice].should_not be_nil
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end

      it "no deberia mostrar el event si este no esta publicado" do
        event_taken  = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')

        post :create, purchase: @valid_attributes, id: event_taken, corporative_id: @efi.search_name
        response.should redirect_to(corporative_root_path(@efi.search_name))
      end
    end

    context "cuando no tiene los puntos suficientes" do
      it "no debe guardar" do
        invalid_attributes = @valid_attributes.clone
        invalid_attributes[:rut] = @account2.rut
        invalid_attributes[:password] = @account2.password

        @account2.points.should eq 0

        post :create, purchase: invalid_attributes, corporative_id: @efi.search_name, id: @event.id
        response.should render_template("new")
      end
    end
  end

end
