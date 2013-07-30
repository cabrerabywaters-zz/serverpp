require 'spec_helper'

describe PuntosPoint::InterestsController do
  login_admin

  before :each do
    @interest = FactoryGirl.create(:interest)

    @valid_attributes = { name: 'Super interest de prueba' }
  end

  describe "GET index" do
    it "assigns all interests as @interests" do
      get :index
      assigns(:interests).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested interest as @interest" do
      get :show, id: @interest
      assigns(:interest).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new interest as @interest" do
      get :new
      assigns(:interest).should be_a_new(Interest)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested interest as @interest" do
      get :edit, id: @interest
      assigns(:interest).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Interest" do
        expect {
          post :create, interest: @valid_attributes
        }.to change(Interest, :count).by(1)
      end

      it "assigns a newly created interest as @interest" do
        post :create, interest: @valid_attributes
        assigns(:interest).should be_a(Interest)
        assigns(:interest).should be_persisted
      end

      it "redirects to the created interest" do
        post :create, interest: @valid_attributes
        response.should redirect_to(puntos_point_interests_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved interest as @interest" do
        post :create, interest: { name: "" }
        assigns(:interest).should be_a_new(Interest)
      end

      it "re-renders the 'new' template" do
        post :create, interest: { name: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested interest" do
        Interest.any_instance.should_receive(:update_attributes).with(@valid_attributes.as_json)
        put :update, id: @interest, interest: @valid_attributes
      end

      it "assigns the requested interest as @interest" do
        put :update, id: @interest, interest: @valid_attributes
        assigns(:interest).should eq(@interest)
      end

      it "redirects to the interest" do
        put :update, id: @interest, interest: @valid_attributes
        response.should redirect_to(puntos_point_interests_path)
      end
    end

    describe "with invalid params" do
      it "assigns the interest as @interest" do
        put :update, id: @interest, interest:  { name: "" }
        assigns(:interest).should eq(@interest)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @interest, interest:  { name: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested interest" do
      expect {
        delete :destroy, id: @interest
      }.to change(Interest, :count).by(-1)
    end

    it "redirects to the interests list" do
      delete :destroy, id: @interest
      response.should redirect_to(puntos_point_interests_url)
    end
  end

end
