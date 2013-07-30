require 'spec_helper'

describe PuntosPoint::CategoriesController do
  login_admin

  before :each do
    @category = FactoryGirl.create(:category)
    @category2 = FactoryGirl.create(:category)

    icon = ActionDispatch::Http::UploadedFile.new( { filename: 'category.ico',
                                                     type: 'image/ico',
                                                     tempfile: File.new(Rails.root + 'spec/fixtures/category.ico')  })

    @valid_attributes = { 'name' => 'Super categoria de prueba', 'icon' => icon, 'texture_name' => Category::TEXTURES.last}
  end

  describe "GET index" do
    it "assigns all categories as @categories" do
      get :index
      assigns(:categories).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested category as @category" do
      get :show, id: @category
      assigns(:category).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new
      assigns(:category).should be_a_new(Category)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested category as @category" do
      get :edit, id: @category
      assigns(:category).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, category: @valid_attributes
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, category: @valid_attributes
        assigns(:category).should be_a(Category)
        assigns(:category).should be_persisted
      end

      it "redirects to the created category" do
        post :create, category: @valid_attributes
        response.should redirect_to(puntos_point_categories_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        post :create, category: { name: "" }
        assigns(:category).should be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        post :create, category: { name: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested category" do
        Category.any_instance.should_receive(:update_attributes).with(@valid_attributes)
        put :update, id: @category, category: @valid_attributes
      end

      it "assigns the requested category as @category" do
        put :update, id: @category, category: @valid_attributes
        assigns(:category).should eq(@category)
      end

      it "redirects to the category" do
        put :update, id: @category, category: @valid_attributes
        response.should redirect_to(puntos_point_categories_path)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        put :update, id: @category, category:  { name: "" }
        assigns(:category).should eq(@category)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @category, category:  { name: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested category" do
      expect {
        delete :destroy, id: @category
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      delete :destroy, id: @category
      response.should redirect_to(puntos_point_categories_url)
    end
  end

end
