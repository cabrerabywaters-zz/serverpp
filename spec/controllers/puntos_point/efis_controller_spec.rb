require 'spec_helper'

describe PuntosPoint::EfisController do
  login_admin

  before :each do
    @efi = FactoryGirl.create(:efi)

    image = ActionDispatch::Http::UploadedFile.new( { filename: 'efi_logo.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/efi_logo.jpg')  })
    industry = FactoryGirl.create(:industry)

    @valid_attributes = { 'name' => 'Super efi de prueba', 'rut' => Run.for(:efi, :rut), 'logo' => image, 'industry_ids' => ['', industry.id.to_s], 'zona' => 'Puntos mi club', 'search_name' => 'super_efi', 'connector_name' => 'BaseConnector', 'compared' => '1' }
  end

  describe "GET index" do
    it "assigns all efis as @efis" do
      get :index
      assigns(:efis).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested efi as @efi" do
      get :show, id: @efi
      assigns(:efi).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new efi as @efi" do
      get :new
      assigns(:efi).should be_a_new(Efi)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested efi as @efi" do
      get :edit, id: @efi
      assigns(:efi).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Efi" do
        expect {
          post :create, efi: @valid_attributes
        }.to change(Efi, :count).by(1)
      end

      it "assigns a newly created efi as @efi" do
        post :create, efi: @valid_attributes
        assigns(:efi).should be_a(Efi)
        assigns(:efi).should be_persisted
      end

      it "redirects to the created efi" do
        post :create, efi: @valid_attributes
        response.should redirect_to(puntos_point_efis_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved efi as @efi" do
        post :create, efi: { name: "" }
        assigns(:efi).should be_a_new(Efi)
      end

      it "re-renders the 'new' template" do
        post :create, efi: { name: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested efi" do
        Efi.any_instance.should_receive(:update_attributes).with(@valid_attributes, as: :puntos_point)
        put :update, id: @efi, efi: @valid_attributes
      end

      it "assigns the requested efi as @efi" do
        put :update, id: @efi, efi: @valid_attributes
        assigns(:efi).should eq(@efi)
      end

      it "redirects to the efi" do
        put :update, id: @efi, efi: @valid_attributes
        response.should redirect_to(puntos_point_efis_path)
      end
    end

    describe "with invalid params" do
      it "assigns the efi as @efi" do
        put :update, id: @efi, efi:  { name: "" }
        assigns(:efi).should eq(@efi)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @efi, efi:  { name: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested efi" do
      expect {
        delete :destroy, id: @efi
      }.to change(Efi, :count).by(-1)
    end

    it "redirects to the efis list" do
      delete :destroy, id: @efi
      response.should redirect_to(puntos_point_efis_url)
    end
  end

end
