require 'spec_helper'

describe PuntosPoint::UserEfisController do
  login_admin

  before :each do
    @user_efi = FactoryGirl.create(:user_efi)

    valid_rut = Run.for(:user_efi, :rut)

    efi = FactoryGirl.create(:efi)

    @valid_attributes = {first_lastname: 'Perez', names: 'Pedro Pablo', nickname: 'pperez', rut: valid_rut, second_lastname: 'Pereira', email: 'pperez@test.cl', password: '123456789', password_confirmation: '123456789', efi_id: efi.id.to_s }
    @valid_attributes_without_password = {first_lastname: 'Perez', names: 'Pedro Pablo', nickname: 'pperez', rut: valid_rut, second_lastname: 'Pereira', email: 'pperez@test.cl', password: '', password_confirmation: '', efi_id: efi.id.to_s }
  end

  describe "GET index" do
    it "assigns all user_efis as @user_efis" do
      get :index
      assigns(:user_efis).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested user_efi as @user_efi" do
      get :show, id: @user_efi
      assigns(:user_efi).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new user_efi as @user_efi" do
      get :new
      assigns(:user_efi).should be_a_new(UserEfi)
      response.should be_success
      response.should render_template("new")
    end

    context 'when no efi in the system' do
      it "redirects to the efis new path and set a notice" do
        Efi.destroy_all
        get :new
        flash[:notice].should_not be_nil
        response.should redirect_to(puntos_point_efis_path)
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested user_efi as @user_efi" do
      get :edit, id: @user_efi
      assigns(:user_efi).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserEfi" do
        expect {
          post :create, user_efi: @valid_attributes
        }.to change(UserEfi, :count).by(1)
      end

      it "assigns a newly created user_efi as @user_efi" do
        post :create, user_efi: @valid_attributes
        assigns(:user_efi).should be_a(UserEfi)
        assigns(:user_efi).should be_persisted
      end

      it "redirects to the created user_efi" do
        post :create, user_efi: @valid_attributes
        response.should redirect_to(puntos_point_user_efis_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_efi as @user_efi" do
        post :create, user_efi: { names: "" }
        assigns(:user_efi).should be_a_new(UserEfi)
      end

      it "re-renders the 'new' template" do
        post :create, user_efi: { names: "" }
        response.should render_template("new")
      end
    end

    context 'when no efi in the system' do
      it "redirects to the efis new path and set a notice" do
        Efi.destroy_all
        get :new
        flash[:notice].should_not be_nil
        response.should redirect_to(puntos_point_efis_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_efi with new password" do
        UserEfi.any_instance.should_receive(:update_attributes).with(@valid_attributes.as_json, as: :puntos_point)
        put :update, id: @user_efi, user_efi: @valid_attributes
      end

      it "updates the requested user_efi without new password" do
        UserEfi.any_instance.should_receive(:update_without_password).with(@valid_attributes_without_password.as_json, as: :puntos_point)
        put :update, id: @user_efi, user_efi: @valid_attributes_without_password
      end

      it "assigns the requested user_efi as @user_efi" do
        put :update, id: @user_efi, user_efi: @valid_attributes
        assigns(:user_efi).should eq(@user_efi)
      end

      it "redirects to the user_efi" do
        put :update, id: @user_efi, user_efi: @valid_attributes
        response.should redirect_to(puntos_point_user_efis_path)
      end
    end

    describe "with invalid params" do
      it "assigns the user_efi as @user_efi" do
        put :update, id: @user_efi, user_efi:  { names: "" }
        assigns(:user_efi).should eq(@user_efi)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @user_efi, user_efi:  { names: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_efi" do
      expect {
        delete :destroy, id: @user_efi
      }.to change(UserEfi, :count).by(-1)
    end

    it "redirects to the user_efis list" do
      delete :destroy, id: @user_efi
      response.should redirect_to(puntos_point_user_efis_url)
    end
  end

end
