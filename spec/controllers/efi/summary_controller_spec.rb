require 'spec_helper'

describe Efi::SummaryController do
  login_user_efi

  before :each do
    @efi     = @current_user_efi.efi

    @event1 = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')
    @event2 = FactoryGirl.create(:event, efi_id: @efi.id, state: 'closed')
    @event3 = FactoryGirl.create(:event, efi_id: @efi.id, state: 'billed')
    @event4 = FactoryGirl.create(:event, efi_id: @efi.id, state: 'paid')

  end

  describe "GET index" do
    it "assigns all events as @events" do
      get :index
      assigns(:events).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "no debe mostrar eventos de otras EFI's" do
      event = FactoryGirl.create(:event, state: 'closed')
      get :index
      assigns(:events).should_not include(event)
      response.should be_success
      response.should render_template("index")
    end
  end

end
