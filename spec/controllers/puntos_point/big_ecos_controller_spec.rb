require 'spec_helper'

describe PuntosPoint::BigEcosController do
  login_admin

  before :each do
    @eco  = FactoryGirl.create(:eco, bigger: true)

    image = ActionDispatch::Http::UploadedFile.new( { filename: 'eco_logo.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/eco_logo.jpg') })

    comuna = FactoryGirl.create(:comuna)
    admin  = FactoryGirl.create(:admin)

    @valid_attributes = { 'name' => 'Super eco de prueba',
                          'rut' => Run.for(:eco, :rut),
                          'logo' => image,
                          'webpage' => 'http://www.pagina-eco-test.cl',
                          'images' => 'true',
                          'fancy_name' => 'Super eco de prueba LTDA',
                          'address' => 'evergreen terras 731',
                          'discount' => '30',
                          'fee' => '40',
                          'comuna_id' => comuna.id.to_s,
                          'admin_id' => admin.id.to_s,
                          'description' => 'Esta es la mejor de la ECO'
                        }
  end

  describe "GET index" do
    it "assigns all ecos as @ecos" do
      get :index
      assigns(:ecos).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo las ECO grande" do
      FactoryGirl.create(:eco, bigger: false)

      get :index
      assigns(:ecos).should eq [@eco]
    end
  end

  describe "GET show" do
    it "assigns the requested eco as @eco" do
      get :show, id: @eco
      assigns(:eco).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new eco as @eco" do
      get :new
      assigns(:eco).should be_a_new(Eco)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested eco as @eco" do
      get :edit, id: @eco
      assigns(:eco).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Eco" do
        expect {
          post :create, eco: @valid_attributes
        }.to change(Eco, :count).by(1)
      end

      it "assigns a newly created eco as @eco" do
        post :create, eco: @valid_attributes
        assigns(:eco).should be_a(Eco)
        assigns(:eco).should be_persisted
      end

      it "redirects to the created eco" do
        post :create, eco: @valid_attributes
        response.should redirect_to(puntos_point_big_ecos_path)
      end

      it "debe setear la eco como grande" do
        post :create, eco: @valid_attributes
        assigns(:eco).bigger.should eq true
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved eco as @eco" do
        post :create, eco: { name: "" }
        assigns(:eco).should be_a_new(Eco)
      end

      it "re-renders the 'new' template" do
        post :create, eco: { name: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested eco" do
        Eco.any_instance.should_receive(:update_attributes).with(@valid_attributes, as: :puntos_point)
        put :update, id: @eco, eco: @valid_attributes
      end

      it "assigns the requested eco as @eco" do
        put :update, id: @eco, eco: @valid_attributes
        assigns(:eco).should eq(@eco)
      end

      it "redirects to the eco" do
        put :update, id: @eco, eco: @valid_attributes
        response.should redirect_to(puntos_point_big_ecos_path)
      end

      it "debe setear la eco como grande" do
        post :create, eco: @valid_attributes
        assigns(:eco).bigger.should eq true
      end
    end

    describe "with invalid params" do
      it "assigns the eco as @eco" do
        put :update, id: @eco, eco:  { name: "" }
        assigns(:eco).should eq(@eco)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @eco, eco:  { name: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested eco" do
      expect {
        delete :destroy, id: @eco
      }.to change(Eco, :count).by(-1)
    end

    it "redirects to the ecos list" do
      delete :destroy, id: @eco
      response.should redirect_to(puntos_point_big_ecos_url)
    end
  end

end
