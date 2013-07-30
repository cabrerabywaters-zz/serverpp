require 'spec_helper'

describe Efi::TradesController do
  login_user_efi

  before :each do
    @user_efi = @current_user_efi
    @efi = @user_efi.efi
  end

  describe "GET category" do
    it "assigns report as @trades" do
      get :category
      assigns(:trades).should_not be_nil
      response.should be_success
      response.should render_template("category")
    end

    it "assigns filters as @interest_ids" do
      get :category
      assigns(:interest_ids).should_not be_nil
      response.should be_success
      response.should render_template("category")
    end
  end

  describe "GET efi" do
    it "assigns report as @trades" do
      get :efi
      assigns(:trades).should_not be_nil
      response.should be_success
      response.should render_template("efi")
    end

    it "no debe poder acceder si la efi no se muestra" do
      @efi.compared = false
      @efi.save
      get :efi
      flash[:notice].should_not be_nil
      response.should redirect_to(efi_root_path)
    end

    it "assigns filters as @interest_ids" do
      get :efi
      assigns(:interest_ids).should_not be_nil
      response.should be_success
      response.should render_template("efi")
    end

    it "assigns filters as @category_ids" do
      get :efi
      assigns(:category_ids).should_not be_nil
      response.should be_success
      response.should render_template("efi")
    end
  end

end
