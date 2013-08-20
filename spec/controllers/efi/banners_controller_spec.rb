require 'spec_helper'

describe Efi::BannersController do
  login_user_efi

  before :each do
    @efi = @current_user_efi.efi
    @event = FactoryGirl.create(:event, efi_id: @efi.id)

    @banner  = FactoryGirl.create(:banner, event_id: @event.id)
    @banner2 = FactoryGirl.create(:banner)


    image = ActionDispatch::Http::UploadedFile.new( { filename: 'banner.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/banner.jpg')  })

    @valid_attributes = { 'image' => image, 'event_id' => @event.id.to_s, 'published' => 'true'}
  end

  describe "GET index" do
    it "assigns all banners as @banners" do
      get :index
      assigns(:banners).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los Banners de la Efi del usuario logeado" do
      get :index
      assigns(:banners).should eq [@banner]
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested banner as @banner" do
      get :show, id: @banner
      assigns(:banner).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "cuando la Banner no es de la Efi del usuario logeado" do
      it "no debe mostrar la Banner" do
        expect{ get :show, id: @banner2 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

  describe "GET new" do
    it "assigns a new banner as @banner" do
      get :new
      assigns(:banner).should be_a_new(Banner)
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

    it "deberia mostrar los events tomados y publicados" do
      event_taken     = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')
      event_published = FactoryGirl.create(:event, efi_id: @efi.id, state: 'published')

      get :new
      assigns(:events).should include(event_taken, event_published)
    end
  end

  describe "GET edit" do
    it "assigns the requested banner as @banner" do
      get :edit, id: @banner
      assigns(:banner).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end

    context "cuando el Banner no es de la Efi del usuario logeado" do
      it "no debe mostrar la Banner" do
        expect {
          get :edit, id: @banner2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end

    it "debe assignar los eventos disponibles" do
      get :edit, id: @banner
      assigns(:events).should_not be_nil
    end

    it "deberia mostrar los events tomados y publicados" do
      event_taken     = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')
      event_published = FactoryGirl.create(:event, efi_id: @efi.id, state: 'published')

      get :edit, id: @banner
      assigns(:events).should include(event_taken, event_published)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Banner" do
        expect {
          post :create, banner: @valid_attributes
        }.to change(Banner, :count).by(1)
      end

      it "assigns a newly created banner as @banner" do
        post :create, banner: @valid_attributes
        assigns(:banner).should be_a(Banner)
        assigns(:banner).should be_persisted
      end

      it "redirects to the created banner" do
        post :create, banner: @valid_attributes
        response.should redirect_to(efi_banners_path)
      end

      context "cuando no hay eventos" do
        it "debe generar una excepcion al no poder crear el banner con id distinto del id del usuario logeado" do
          Event.destroy_all
          expect {
            post :create, banner: @valid_attributes
          }.to raise_error(CanCan::AccessDenied)
        end
      end

      context "cuando hay eventos pero ninguno esta :taken" do
        it "debe generar una excepcion al no poder crear el banner con id distinto del id del usuario logeado" do
          Event.destroy_all
          FactoryGirl.create(:event, efi_id: @efi.id, state: 'closed')
          expect {
            post :create, banner: @valid_attributes
          }.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved banner as @banner" do
        post :create, banner: { event_id: @event.id }
        assigns(:banner).should be_a_new(Banner)
      end

      it "re-renders the 'new' template" do
        post :create, banner: { event_id: @event.id }
        response.should render_template("new")
      end

      it "debe assignar los eventos disponibles" do
        post :create, banner: { event_id: @event.id }
        assigns(:events).should_not be_nil
      end

      it "deberia mostrar los events tomados y publicados" do
        event_taken     = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')
        event_published = FactoryGirl.create(:event, efi_id: @efi.id, state: 'published')

        post :create, banner: { event_id: @event.id }
        assigns(:events).should include(event_taken, event_published)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested banner" do
        Banner.any_instance.should_receive(:update_attributes).with(@valid_attributes)
        put :update, id: @banner, banner: @valid_attributes
      end

      it "assigns the requested banner as @banner" do
        put :update, id: @banner, banner: @valid_attributes
        assigns(:banner).should eq(@banner)
      end

      it "redirects to the banner" do
        put :update, id: @banner, banner: @valid_attributes
        response.should redirect_to(efi_banners_path)
      end
    end

    describe "with invalid params" do
      it "assigns the banner as @banner" do
        put :update, id: @banner, banner: { event_id: "" }
        assigns(:banner).should eq(@banner)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @banner, banner:  { event_id: "" }
        response.should render_template("edit")
      end

      context "cuando la Banner no es de la Efi del usuario logeado" do
        it "no debe actualizar la Banner" do
          expect{
            put :update, id: @banner2, banner: {}
          }.to raise_error(ActiveRecord::RecordNotFound)
          response.should be_success
        end
      end

      it "debe assignar los eventos disponibles" do
        put :update, id: @banner, banner:  { event_id: "" }
        assigns(:events).should_not be_nil
      end

      it "deberia mostrar los events tomados y publicados" do
        event_taken     = FactoryGirl.create(:event, efi_id: @efi.id, state: 'taken')
        event_published = FactoryGirl.create(:event, efi_id: @efi.id, state: 'published')

        put :update, id: @banner, banner:  { event_id: "" }
        assigns(:events).should include(event_taken, event_published)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested banner" do
      expect {
        delete :destroy, id: @banner
      }.to change(Banner, :count).by(-1)
    end

    it "redirects to the banners list" do
      delete :destroy, id: @banner
      response.should redirect_to(efi_banners_url)
    end

    context "cuando la Banner no es de la Efi del usuario logeado" do
      it "no debe eliminar la Banner" do
        expect{
          delete :destroy, id: @banner2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

end
