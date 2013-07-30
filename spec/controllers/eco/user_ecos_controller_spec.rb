# encoding: utf-8
require 'spec_helper'

describe Eco::UserEcosController do
  login_user_eco

  before :each do
    @user_eco = @current_user_eco

    valid_rut = Run.for(:user_eco, :rut)

    image = ActionDispatch::Http::UploadedFile.new( { filename: 'eco_logo.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/eco_logo.jpg')  })

    eco =  {"name"=>"Entel PCS", "rut"=>"111111111", "id"=>"1", "logo" => image, 'webpage' => 'http://www.holamundo.cl'}

    @valid_attributes = {'first_lastname' => 'Perez', 'names' => 'Pedro Pablo', 'nickname' => 'pperez', 'rut' => valid_rut, 'second_lastname' => 'Pereira', 'email' => 'pperez@test.cl', 'password' => '123456789', 'password_confirmation' => '123456789', 'eco_attributes' => eco}
    @valid_attributes_without_password = {'first_lastname' => 'Perez', 'names' => 'Pedro Pablo', 'nickname' => 'pperez', 'rut' => valid_rut, 'second_lastname' => 'Pereira', 'email' => 'pperez@test.cl', 'password' => '', 'password_confirmation' => '', 'eco_attributes' => eco }
  end

  describe "GET edit" do
    it "assigns the requested user_eco as @user_eco" do
      get :edit, id: @user_eco
      assigns(:user_eco).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :edit, id: @user_eco
      }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_eco with new password" do
        UserEco.any_instance.should_receive(:update_attributes).with(@valid_attributes)
        put :update, id: @user_eco, user_eco: @valid_attributes
      end

      it "updates the requested user_eco without new password" do
        UserEco.any_instance.should_receive(:update_without_password).with(@valid_attributes_without_password)
        put :update, id: @user_eco, user_eco: @valid_attributes_without_password
      end

      it "assigns the requested user_eco as @user_eco" do
        put :update, id: @user_eco, user_eco: @valid_attributes
        assigns(:user_eco).should eq(@user_eco)
      end

      it "redirects to the user_eco" do
        put :update, id: @user_eco, user_eco: @valid_attributes
        response.should redirect_to(edit_eco_user_eco_path(@user_eco))
      end
    end

    describe "with invalid params" do
      it "assigns the user_eco as @user_eco" do
        put :update, id: @user_eco, user_eco:  { names: "" }
        assigns(:user_eco).should eq(@user_eco)
      end

      context "when try to assign not available attribute :eco_id" do
        it "not save @user_eco and raise a MassAssignmentSecurity Error" do
          expect do
            put :update, id: @user_eco, user_eco:  { eco_id: FactoryGirl.create(:eco).id }
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end

      context "when try to assign not available attribute :search_name" do
        it "not save @user_eco and raise a MassAssignmentSecurity Error" do
          expect do
            put :update, id: @user_eco, user_eco:  {eco_attributes: {search_name: 'no deberia guardar'} }
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end

      it "re-renders the 'edit' template" do
        put :update, id: @user_eco, user_eco:  { names: "" }
        response.should render_template("edit")
      end
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        put :update, id: @user_eco, user_eco: @valid_attributes
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
