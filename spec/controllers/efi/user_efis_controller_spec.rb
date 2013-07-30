require 'spec_helper'

describe Efi::UserEfisController do
  login_user_efi

  before :each do
    @user_efi = @current_user_efi

    valid_rut = Run.for(:user_efi, :rut)


    image = ActionDispatch::Http::UploadedFile.new( { filename: 'efi_logo.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/efi_logo.jpg')  })

    efi =  {"name"=>"Entel PCS", "rut"=>"111111111", "id"=>"1", "logo" => image}

    @valid_attributes = {'first_lastname' => 'Perez', 'names' => 'Pedro Pablo', 'nickname' => 'pperez', 'rut' => valid_rut, 'second_lastname' => 'Pereira', 'email' => 'pperez@test.cl', 'password' => '123456789', 'password_confirmation' => '123456789', 'efi_attributes' => efi}
    @valid_attributes_without_password = {'first_lastname' => 'Perez', 'names' => 'Pedro Pablo', 'nickname' => 'pperez', 'rut' => valid_rut, 'second_lastname' => 'Pereira', 'email' => 'pperez@test.cl', 'password' => '', 'password_confirmation' => '', 'efi_attributes' => efi }
  end

  describe "GET edit" do
    it "assigns the requested user_efi as @user_efi" do
      get :edit, id: @user_efi
      assigns(:user_efi).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_efi with new password" do
        UserEfi.any_instance.should_receive(:update_attributes).with(@valid_attributes)
        put :update, id: @user_efi, user_efi: @valid_attributes
      end

      it "updates the requested user_efi without new password" do
        UserEfi.any_instance.should_receive(:update_without_password).with(@valid_attributes_without_password)
        put :update, id: @user_efi, user_efi: @valid_attributes_without_password
      end

      it "assigns the requested user_efi as @user_efi" do
        put :update, id: @user_efi, user_efi: @valid_attributes
        assigns(:user_efi).should eq(@user_efi)
      end

      it "redirects to the user_efi" do
        put :update, id: @user_efi, user_efi: @valid_attributes
        response.should redirect_to(edit_efi_user_efi_path(@user_efi))
      end
    end

    describe "with invalid params" do
      it "assigns the user_efi as @user_efi" do
        put :update, id: @user_efi, user_efi:  { names: "" }
        assigns(:user_efi).should eq(@user_efi)
      end

      context "when try to assign not available attribute :efi_id" do
        it "not save @user_efi and raise a MassAssignmentSecurity Error" do
          expect do
            put :update, id: @user_efi, user_efi:  { efi_id: FactoryGirl.create(:efi).id }
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end

      context "when try to assign not available attributes" do
        it "for :search_name, not save @user_efi and raise a MassAssignmentSecurity Error" do
          expect do
            put :update, id: @user_efi, user_efi:  {efi_attributes: {search_name: 'no deberia guardar'}}
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end

        it "for :compared, not save @user_efi and raise a MassAssignmentSecurity Error" do
          expect do
            put :update, id: @user_efi, user_efi:  {efi_attributes: {compared: '0' }}
          end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end

      it "re-renders the 'edit' template" do
        put :update, id: @user_efi, user_efi:  { names: "" }
        response.should render_template("edit")
      end
    end
  end

end
