require 'spec_helper'

describe Efi::PublicitiesController do
  login_user_efi

  before :each do
    @efi   = @current_user_efi.efi
    @event = FactoryGirl.create(:event, efi_id: @efi.id)

    @publicity  = FactoryGirl.create(:publicity, event_id: @event.id)
    @publicity2 = FactoryGirl.create(:publicity)


    image = ActionDispatch::Http::UploadedFile.new({ filename: 'publicity.jpeg',
                                                     type: 'image/jpeg',
                                                     tempfile: File.new(Rails.root + 'spec/fixtures/publicities/publicity.jpeg') })

    @valid_attributes = { 'image' => image,
                          'event_id' => @event.id.to_s }
  end

  describe "GET index" do
    it "assigns all publicity as @publicities" do
      get :index
      assigns(:publicities).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los publicities de la Efi del usuario logeado" do
      get :index
      assigns(:publicities).should eq [@publicity]
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested publicity as @publicity" do
      get :show, id: @publicity
      assigns(:publicity).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "cuando la publicity no es de la Efi del usuario logeado" do
      it "no debe mostrar la publicity" do
        expect{
          get :show, id: @publicity2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

  describe "GET new" do
    it "assigns a new publicity as @publicity" do
      get :new
      assigns(:publicity).should be_a_new(Publicity)
      response.should be_success
      response.should render_template("new")
    end

    it "debe redirigir al home si no tiene eventos disponibles" do
      Event.destroy_all
      get :new
      flash[:notice].should_not be_nil
      response.should redirect_to(efi_root_path)
    end

    it "debe redirigir al home si no tiene eventos disponibles que esten taken" do
      Event.destroy_all
      FactoryGirl.create(:event, efi_id: @efi.id, state: 'closed')
      get :new
      flash[:notice].should_not be_nil
      response.should redirect_to(efi_root_path)
    end

    it "debe assignar los eventos disponibles" do
      get :new
      assigns(:events).should_not be_nil
    end

    it "debe asignar events de ECO's grande" do
      eco1 = FactoryGirl.create(:eco, bigger: true)
      eco2 = FactoryGirl.create(:eco, bigger: false)

      experience1 = FactoryGirl.create(:experience, eco_id: eco1.id)
      experience2 = FactoryGirl.create(:experience, eco_id: eco2.id)

      event1 = FactoryGirl.create(:event, experience_id: experience1.id, efi_id: @efi.id)
      event2 = FactoryGirl.create(:event, experience_id: experience2.id, efi_id: @efi.id)

      get :new
      assigns(:events).should include(event1)
      assigns(:events).should_not include(event2)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new publicity" do
        expect {
          post :create, publicity: @valid_attributes
        }.to change(Publicity, :count).by(1)
      end

      it "assigns a newly created publicity as @publicity" do
        post :create, publicity: @valid_attributes
        assigns(:publicity).should be_a(Publicity)
        assigns(:publicity).should be_persisted
      end

      it "redirects to the publicities path" do
        post :create, publicity: @valid_attributes
        response.should redirect_to(efi_publicities_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved publicity as @publicity" do
        post :create, publicity: { event_id: @event.id }
        assigns(:publicity).should be_a_new(Publicity)
      end

      it "re-renders the 'new' template" do
        post :create, publicity: { event_id: @event.id }
        response.should render_template("new")
      end

      it "debe assignar los eventos disponibles" do
        post :create, publicity: { event_id: @event.id }
        assigns(:events).should_not be_nil
      end


      it "debe asignar events de ECO's grande" do
        eco1 = FactoryGirl.create(:eco, bigger: true)
        eco2 = FactoryGirl.create(:eco, bigger: false)

        experience1 = FactoryGirl.create(:experience, eco_id: eco1.id)
        experience2 = FactoryGirl.create(:experience, eco_id: eco2.id)

        event1 = FactoryGirl.create(:event, experience_id: experience1.id, efi_id: @efi.id)
        event2 = FactoryGirl.create(:event, experience_id: experience2.id, efi_id: @efi.id)

        post :create, publicity: { event_id: @event.id }
        assigns(:events).should include(event1)
        assigns(:events).should_not include(event2)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested publicity" do
      expect {
        delete :destroy, id: @publicity
      }.to change(Publicity, :count).by(-1)
    end

    it "redirects to the publicities list" do
      delete :destroy, id: @publicity
      response.should redirect_to(efi_publicities_url)
    end

    context "cuando la publicity no es de la Efi del usuario logeado" do
      it "no debe eliminar la publicity" do
        expect{
          delete :destroy, id: @publicity2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

end
