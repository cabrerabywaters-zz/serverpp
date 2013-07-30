require 'spec_helper'

describe PuntosPoint::UserEcosController do
  login_admin

  before :each do
    @user_eco = FactoryGirl.create(:user_eco)

    valid_rut = Run.for(:user_eco, :rut)

    eco   = @user_eco.eco
    group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)

    @valid_attributes = { first_lastname: 'Perez',
                          names: 'Pedro Pablo',
                          nickname: 'pperez',
                          rut: valid_rut,
                          second_lastname: 'Pereira',
                          email: 'pperez@test.cl',
                          password: '123456789',
                          password_confirmation: '123456789',
                          eco_id: eco.id.to_s,
                          group: group.id.to_s}

    @valid_attributes_without_password = {first_lastname: 'Perez',
                                          names: 'Pedro Pablo',
                                          nickname: 'pperez',
                                          rut: valid_rut,
                                          second_lastname: 'Pereira',
                                          email: 'pperez@test.cl',
                                          password: '',
                                          password_confirmation: '',
                                          eco_id: eco.id.to_s,
                                          group: group.id.to_s}
  end

  describe "GET index" do
    it "assigns all user_ecos as @user_ecos" do
      get :index
      assigns(:user_ecos).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested user_eco as @user_eco" do
      get :show, id: @user_eco
      assigns(:user_eco).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new user_eco as @user_eco" do
      get :new
      assigns(:user_eco).should be_a_new(UserEco)
      response.should be_success
      response.should render_template("new")
    end

    context 'when no eco in the system' do
      it "redirects to the ecos new path and set a notice" do
        Eco.destroy_all
        get :new
        flash[:notice].should_not be_nil
        response.should redirect_to(puntos_point_small_ecos_path)
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested user_eco as @user_eco" do
      get :edit, id: @user_eco
      assigns(:user_eco).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserEco" do
        expect {
          post :create, user_eco: @valid_attributes
        }.to change(UserEco, :count).by(1)
      end

      it "assigns a newly created user_eco as @user_eco" do
        post :create, user_eco: @valid_attributes
        assigns(:user_eco).should be_a(UserEco)
        assigns(:user_eco).should be_persisted
      end

      it "redirects to the created user_eco" do
        post :create, user_eco: @valid_attributes
        response.should redirect_to(puntos_point_user_ecos_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_eco as @user_eco" do
        post :create, user_eco: { names: "" }
        assigns(:user_eco).should be_a_new(UserEco)
      end

      it "re-renders the 'new' template" do
        post :create, user_eco: { names: "" }
        response.should render_template("new")
      end

      it "no debe asignar grupos diferentes de los definidos para eco" do
        valid_attributes_copy = @valid_attributes.clone
        valid_attributes_copy[:group] = FactoryGirl.create(:burlesque_group).id
        expect {
          post :create, user_eco: valid_attributes_copy
        }.to change(UserEco, :count).by(0)
      end
    end

    context 'when no eco in the system' do
      it "redirects to the ecos new path and set a notice" do
        Eco.destroy_all
        get :new
        flash[:notice].should_not be_nil
        response.should redirect_to(puntos_point_small_ecos_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_eco with new password" do
        UserEco.any_instance.should_receive(:update_attributes).with(@valid_attributes.as_json, as: :puntos_point)
        put :update, id: @user_eco, user_eco: @valid_attributes
      end

      it "updates the requested user_eco without new password" do
        UserEco.any_instance.should_receive(:update_without_password).with(@valid_attributes_without_password.as_json, as: :puntos_point)
        put :update, id: @user_eco, user_eco: @valid_attributes_without_password
      end

      it "assigns the requested user_eco as @user_eco" do
        put :update, id: @user_eco, user_eco: @valid_attributes
        assigns(:user_eco).should eq(@user_eco)
      end

      it "redirects to the user_eco" do
        put :update, id: @user_eco, user_eco: @valid_attributes
        response.should redirect_to(puntos_point_user_ecos_path)
      end

      it "no debe asignar grupos diferentes de los definidos para eco" do
        group = FactoryGirl.create(:burlesque_group)
        put :update, id: @user_eco, user_eco: { group: group.id }
        assigns(:user_eco).groups.should_not include(group)
        response.should redirect_to(puntos_point_user_ecos_path)
      end
    end

    describe "with invalid params" do
      it "assigns the user_eco as @user_eco" do
        put :update, id: @user_eco, user_eco: { names: "" }
        assigns(:user_eco).should eq(@user_eco)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @user_eco, user_eco: { names: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_eco" do
      expect {
        delete :destroy, id: @user_eco
      }.to change(UserEco, :count).by(-1)
    end

    it "redirects to the user_ecos list" do
      delete :destroy, id: @user_eco
      response.should redirect_to(puntos_point_user_ecos_url)
    end
  end

end
