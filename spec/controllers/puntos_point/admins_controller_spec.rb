require 'spec_helper'

describe PuntosPoint::AdminsController do
  login_admin

  before :each do
    @admin = FactoryGirl.create(:admin)

    valid_rut = Run.for(:admin, :rut)

    @valid_attributes = {first_lastname: 'Perez', names: 'Pedro Pablo', nickname: 'pperez', rut: valid_rut, second_lastname: 'Pereira', email: 'pperez@test.cl', password: '123456789', password_confirmation: '123456789' }
    @valid_attributes_without_password = {first_lastname: 'Perez', names: 'Pedro Pablo', nickname: 'pperez', rut: valid_rut, second_lastname: 'Pereira', email: 'pperez@test.cl', password: '', password_confirmation: '' }
  end

  describe "GET index" do
    it "assigns all admins as @admins" do
      get :index
      assigns(:admins).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested admin as @admin" do
      get :show, id: @admin
      assigns(:admin).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new admin as @admin" do
      get :new
      assigns(:admin).should be_a_new(Admin)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested admin as @admin" do
      get :edit, id: @admin
      assigns(:admin).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin" do
        expect {
          post :create, admin: @valid_attributes
        }.to change(Admin, :count).by(1)
      end

      it "assigns a newly created admin as @admin" do
        post :create, admin: @valid_attributes
        assigns(:admin).should be_a(Admin)
        assigns(:admin).should be_persisted
      end

      it "redirects to the created admin" do
        post :create, admin: @valid_attributes
        response.should redirect_to(puntos_point_admins_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin as @admin" do
        post :create, admin: { names: "" }
        assigns(:admin).should be_a_new(Admin)
      end

      it "re-renders the 'new' template" do
        post :create, admin: { names: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin with new password" do
        Admin.any_instance.should_receive(:update_attributes).with(@valid_attributes.as_json)
        put :update, id: @admin, admin: @valid_attributes
      end

      it "updates the requested admin without new password" do
        Admin.any_instance.should_receive(:update_without_password).with(@valid_attributes_without_password.as_json)
        put :update, id: @admin, admin: @valid_attributes_without_password
      end

      it "assigns the requested admin as @admin" do
        put :update, id: @admin, admin: @valid_attributes
        assigns(:admin).should eq(@admin)
      end

      it "redirects to the admin" do
        put :update, id: @admin, admin: @valid_attributes
        response.should redirect_to(puntos_point_admins_path)
      end
    end

    describe "with invalid params" do
      it "assigns the admin as @admin" do
        put :update, id: @admin, admin:  { names: "" }
        assigns(:admin).should eq(@admin)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @admin, admin:  { names: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin" do
      expect {
        delete :destroy, id: @admin
      }.to change(Admin, :count).by(-1)
    end

    it "redirects to the admins list" do
      delete :destroy, id: @admin
      response.should redirect_to(puntos_point_admins_url)
    end
  end

end
