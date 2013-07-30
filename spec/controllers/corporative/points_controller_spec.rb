require 'spec_helper'

describe Corporative::PointsController do
  before :each do
    @corporative = FactoryGirl.create(:efi)
    @account     = FactoryGirl.create(:account, points: 10, efi_id: @corporative.id)
    @account2    = FactoryGirl.create(:account)
  end

  describe "POST create" do
    context "con datos validos" do
      it "assigns points as @points" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: @account.rut, format: :js
        assigns(:points).should_not be_nil
        assigns(:rut).should_not be_nil
        assigns(:valid_run).should be_true
        response.should be_success
      end

      it "assigns requested rut as @rut" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: @account.rut, format: :js
        assigns(:rut).should_not be_nil
        response.should be_success
      end

      it "assigns user points as @points" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: @account.rut, format: :js
        assigns(:points).should eq @account.points
        response.should be_success
      end
    end

    context "con datos invalidos" do
      it "assigns empty @rut" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: '', format: :js
        assigns(:rut).should be_nil
        assigns(:points).should be_nil
        assigns(:valid_run).should be_nil
        response.should be_success
      end

      it "con un rut de otra EFI" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: @account2.rut, format: :js
        assigns(:rut).should_not be_nil
        assigns(:points).should be_nil
        assigns(:valid_run).should be_true
        response.should be_success
      end

      it "con un rut invalido" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: '1-1', format: :js
        assigns(:rut).should_not be_nil
        assigns(:points).should be_nil
        assigns(:valid_run).should be_false
        response.should be_success
      end

      it "formato no apropiado" do
        request.accept = "application/js"
        post :create, corporative_id: @corporative.search_name, rut: @account.rut, format: :html
        response.response_code.should eq 406
      end
    end
  end

end
