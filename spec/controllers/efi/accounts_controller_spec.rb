require 'spec_helper'

describe Efi::AccountsController do
  login_user_efi

  before :each do
    @efi = @current_user_efi.efi
    @account = FactoryGirl.create(:account, efi_id: @efi.id)
    @account2 = FactoryGirl.create(:account)

    transactions = {'0' => { 'points' => '100', 'operation_id' => '1' }}
    @valid_attributes = { 'efi_id' => @efi.id.to_s, 'name' => 'asdf', 'rut' => Run.for(:account, :rut), 'password' => '12345678', 'transactions_attributes' => transactions}
    @valid_attributes_without_password = { 'efi_id' => @efi.id.to_s, 'name' => 'asdf', 'rut' => Run.for(:account, :rut), 'transactions_attributes' => transactions}
  end

  describe "GET index" do
    it "assigns all accounts as @accounts" do
      get :index
      assigns(:accounts).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "deberia mostrar solo los Accounts de la Efi del usuario logeado" do
      get :index
      assigns(:accounts).should eq [@account]
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested account as @account" do
      get :show, id: @account
      assigns(:account).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end

    context "cuando la Account no es de la Efi del usuario logeado" do
      it "no debe mostrar la Account" do
        expect{ get :show, id: @account2 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

  describe "GET new" do
    it "assigns a new account as @account" do
      get :new
      assigns(:account).should be_a_new(Account)
      response.should be_success
      response.should render_template("new")
    end

    it "deberia construir una nueva Transaction" do
      get :new
      assigns(:transaction).should be_a_new(Transaction)
      response.should be_success
    end
  end

  describe "GET edit" do
    it "assigns the requested account as @account" do
      get :edit, id: @account
      assigns(:account).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end

    it "deberia construir una nueva Transaction" do
      get :edit, id: @account
      assigns(:transaction).should be_a_new(Transaction)
      response.should be_success
    end

    context "cuando la Account no es de la Efi del usuario logeado" do
      it "no debe mostrar la Account" do
        expect{ get :edit, id: @account2 }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Account" do
        expect {
          post :create, account: @valid_attributes
        }.to change(Account, :count).by(1)
      end

      it "assigns a newly created account as @account" do
        post :create, account: @valid_attributes
        assigns(:account).should be_a(Account)
        assigns(:account).should be_persisted
      end

      it "redirects to the created account" do
        post :create, account: @valid_attributes
        response.should redirect_to(efi_accounts_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved account as @account" do
        post :create, account: { points: "" }
        assigns(:account).should be_a_new(Account)
      end

      it "re-renders the 'new' template" do
        post :create, account: { points: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested account" do
        Account.any_instance.should_receive(:update_attributes).with(@valid_attributes)
        put :update, id: @account, account: @valid_attributes
      end

      it "updates the requested account without new password" do
        Account.any_instance.should_receive(:update_attributes).with(@valid_attributes_without_password)
        put :update, id: @account, account: @valid_attributes_without_password
      end

      it "assigns the requested account as @account" do
        put :update, id: @account, account: @valid_attributes
        assigns(:account).should eq(@account)
      end

      it "redirects to the account" do
        put :update, id: @account, account: @valid_attributes
        response.should redirect_to(efi_accounts_path)
      end
    end

    describe "with invalid params" do
      it "assigns the account as @account" do
        put :update, id: @account, account: { points: "" }
        assigns(:account).should eq(@account)
      end

      it "re-renders the 'edit' template" do
        put :update, id: @account, account:  { points: "" }
        response.should render_template("edit")
      end

      context "cuando la Account no es de la Efi del usuario logeado" do
        it "no debe actualizar la Account" do
          expect{
            put :update, id: @account2, account: {}
          }.to raise_error(ActiveRecord::RecordNotFound)
          response.should be_success
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested account" do
      expect {
        delete :destroy, id: @account
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the accounts list" do
      delete :destroy, id: @account
      response.should redirect_to(efi_accounts_url)
    end

    context "cuando la Account no es de la Efi del usuario logeado" do
      it "no debe eliminar la Account" do
        expect{
          delete :destroy, id: @account2
        }.to raise_error(ActiveRecord::RecordNotFound)
        response.should be_success
      end
    end
  end

end
