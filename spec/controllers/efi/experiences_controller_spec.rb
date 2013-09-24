require 'spec_helper'

describe Efi::ExperiencesController do
  login_user_efi

  before :each do
    @experience1 = FactoryGirl.create(:experience, available_efi_ids: ['', @current_user_efi.efi.id])
    @experience2 = FactoryGirl.create(:experience, available_efi_ids: ['', @current_user_efi.efi.id])
    @experience3 = FactoryGirl.create(:experience, available_efi_ids: ['', @current_user_efi.efi.id], state: 'draft')
    @experience4 = FactoryGirl.create(:experience)
  end

  describe "GET index" do
    it "assigns all available_experiences as @experiences" do
      get :index
      assigns(:experiences).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo las available_experiences de la efi del user_efi logeado" do
      get :index
      assigns(:experiences).should eq [@experience1, @experience2]
      response.should be_success
    end

    it "deberia mostrar solo las experiences disponibles por fecha" do
      FactoryGirl.create(:experience, starting_at: Date.current + 10.day,
                                      validity_starting_at: Date.current + 10.day,
                                      ending_at: Date.current + 10.day,
                                      validity_ending_at: Date.current + 10.day,
                                      available_efi_ids: ['', @current_user_efi.efi.id])

      get :index
      assigns(:experiences).should eq [@experience1, @experience2]
      response.should be_success
    end

    it "no deberia mostrar las experiences pendientes" do
      get :index
      assigns(:experiences).order(:id).should eq [@experience1, @experience2]
      response.should be_success
    end

    it "no deberia mostrar experiencias que no esten publicadas on en venta" do
      ['draft', 'closed', 'expired'].each do |state|
        experience = FactoryGirl.create(:experience, available_efi_ids: ['', @current_user_efi.efi.id], state: state)

        get :index
        assigns(:experiences).should_not include(experience)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested experience as @experience" do
      get :show, id: @experience1
      assigns(:experience).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "para poder participar en una experience" do
      it "assigns a event as @event" do
        get :show, id: @experience1
        assigns(:event).should_not be_nil
      end

      it "debe construir un nuevo evento" do
        get :show, id: @experience1
        assigns(:event).should_not be_persisted
      end

      it "debe tener al menos un exchange" do
        get :show, id: @experience1
        assigns(:event).exchanges.should_not be_empty
      end
    end

    context "para ver los datos de una experience en la que estoy participando" do
      it "debe asignar el evento existente" do
        event = FactoryGirl.create(:event, experience_id: @experience1.id, efi_id: @current_user_efi.efi_id)
        # current_user_efi.available_experiences.are_published.started.find(params[:id])
        get :show, id: @experience1
        assigns(:event).should be_persisted
      end
    end

    context "cuando la experience esta pendiente" do
      it "no debe mostrar la experience" do
        expect{ get :show, id: @experience3 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end

    context "cuando la experience no es para la efi del user_efi logeado" do
      it "no debe mostrar la experience" do
        expect{ get :show, id: @experience4 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

end
