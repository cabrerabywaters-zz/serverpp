require 'spec_helper'

describe Corporative::EventsController do
  before :each do
    @efi        = FactoryGirl.create(:efi)
    @event      = FactoryGirl.create(:event, efi_id: @efi.id)
    @event2     = FactoryGirl.create(:event)

    @closed_event                   = FactoryGirl.create(:event, efi_id: @efi.id, state: 'closed')

    @future_event                   = FactoryGirl.create(:event, efi_id: @efi.id)
    experience                      = @future_event.experience
    experience.starting_at          = Date.current + 10.day
    experience.ending_at            = Date.current + 10.day
    experience.validity_starting_at = Date.current + 10.day
    experience.validity_ending_at   = Date.current + 10.day
    experience.save
  end

  describe "GET index" do
    it "assigns all events of EFI as @events" do
      get :index, corporative_id: @efi.search_name
      assigns(:events).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los events de la EFI" do
      get :index, corporative_id: @efi.search_name
      assigns(:events).should eq [@event]
      response.should be_success
    end

    it "deberia mostrar solo los events disponible segun rangos de fechas" do
      get :index, corporative_id: @efi.search_name
      assigns(:events).should eq [@event]
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      get :show, id: @event, corporative_id: @efi.search_name
      assigns(:event).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "cuando el Event no pertenece a la EFI" do
      it "no debe mostrar el event" do
        # expect{
        #   get :show, id: @event2, corporative_id: @efi.search_name
        # }.to raise_error(ActiveRecord::RecordNotFound)
        get :show, id: @event2, corporative_id: @efi.search_name
        response.should redirect_to(corporative_root_path(@efi))
      end
    end

    context "cuando el Event ya no esta disponible" do
      it "no deberia mostrar el event si aun no esta disponible segun rangos de fechas" do
        get :show, id: @future_event, corporative_id: @efi.search_name
        response.should redirect_to(corporative_root_path(@efi))
      end

      it "no deberia mostrar el event si este esta cerrado" do
        get :show, id: @closed_event, corporative_id: @efi.search_name
        response.should redirect_to(corporative_root_path(@efi))
      end
    end
  end

end
