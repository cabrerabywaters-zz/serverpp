require 'spec_helper'

describe Efi::EventsController do
  login_user_efi

  before :each do
    @efi        = @current_user_efi.efi
    @experience = FactoryGirl.create(:experience)
    @efi.industries << @experience.industry_experiences.first.industry
    @efi.reload
    @experience.available_efis << @efi
    @another_experience = FactoryGirl.create(:experience)

    exchanges = {'0' => {points: 1, cash: ""}}

    @valid_attributes1 = {'exclusivity_id' => Exclusivity.total_id, 'exchanges_attributes' => exchanges }
    @valid_attributes2 = {'exclusivity_id' => Exclusivity.by_industry_id, 'exchanges_attributes' => exchanges }
    @valid_attributes3 = {'exclusivity_id' => Exclusivity.without_id, 'swaps' => 1, 'exchanges_attributes' => exchanges }

    @event1 = FactoryGirl.create(:event, efi_id: @efi.id)
    @event2 = FactoryGirl.create(:event)
  end

  describe "GET index" do
    it "assigns all events as @events" do
      get :index
      assigns(:events).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los eventos del usuario logeado" do
      get :index
      assigns(:events).should eq [@event1]
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      get :show, id: @event1
      assigns(:event).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    it "assigns the associates experience as @experience" do
      get :show, id: @event1
      assigns(:experience).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      context "cuando el evento es exclusividad total" do
        it "creates a new Event" do
          expect {
            post :create, event: @valid_attributes1, experience_id: @experience.id
          }.to change(Event, :count).by(1)
        end

        it "assigns a newly created event as @event" do
          post :create, event: @valid_attributes1, experience_id: @experience.id
          assigns(:event).should be_a(Event)
          assigns(:event).should be_persisted
        end

        it "redirects to the created event" do
          post :create, event: @valid_attributes1, experience_id: @experience.id
          response.should redirect_to(efi_experience_path(@experience))
        end
      end
      context "cuando el evento es exclusividad por industria" do
        it "creates a new Event" do
          expect {
            post :create, event: @valid_attributes2, experience_id: @experience.id
          }.to change(Event, :count).by(1)
        end

        it "assigns a newly created event as @event" do
          post :create, event: @valid_attributes2, experience_id: @experience.id
          assigns(:event).should be_a(Event)
          assigns(:event).should be_persisted
        end

        it "redirects to the created event" do
          post :create, event: @valid_attributes2, experience_id: @experience.id
          response.should redirect_to(efi_experience_path(@experience))
        end
      end

      context "cuando el evento es sin exclusividad" do
        it "creates a new Event" do
          expect {
            post :create, event: @valid_attributes3, experience_id: @experience.id
          }.to change(Event, :count).by(1)
        end

        it "assigns a newly created event as @event" do
          post :create, event: @valid_attributes3, experience_id: @experience.id
          assigns(:event).should be_a(Event)
          assigns(:event).should be_persisted
        end

        it "redirects to the created event" do
          post :create, event: @valid_attributes3, experience_id: @experience.id
          response.should redirect_to(efi_experience_path(@experience))
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, event: { exclusivity_id: Exclusivity.without_id }, experience_id: @experience.id
        assigns(:event).should be_a_new(Event)
      end

      it "re-renders the 'efi/experiences/show' template" do
        post :create, event: { exclusivity_id: Exclusivity.without_id }, experience_id: @experience.id
        response.should render_template("efi/experiences/show")
      end

      it "assigns a required experience" do
        post :create, event: { exclusivity_id: Exclusivity.without_id }, experience_id: @experience.id
        assigns(:experience).should be_a(Experience)
      end

      context "when try to assign not available attribute :quantity" do
        it "not save @event and raise a MassAssignmentSecurity Error" do
          expect do
            post :create, event: { quantity: 1 }, experience_id: @experience.id
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end

      context "cuando el usuario logeado no puede acceder a la experience" do
        it "no debe mostrar el coupon de otra company" do
          expect{
            post :create, event: { }, experience_id: @another_experience.id
          }.to raise_error(ActiveRecord::RecordNotFound)
          response.should be_success
        end
      end

      context "cuando la experience no esta publicada ni on_sale" do
        it "debe generar un error al no encontrar la experiencia" do
          ['pending', 'closed', 'expired', 'billed', 'paid'].each do |state|
            experience = FactoryGirl.create(:experience, available_efi_ids: ['', @efi.id], state: state)

            expect {
              post :create, event: { }, experience_id: experience.id
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end

end
