# encoding: utf-8
require 'spec_helper'

describe Eco::IncomesController, broken: true do
  login_user_eco

  before :each do
    @eco          = @current_user_eco.eco

    @experience1  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'expired')
    @experience2  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'billed')
    @experience3  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'paid')

    @experience4 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'pending')
    @experience5 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
    @experience6 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'on_sale')
    @experience7 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'closed')
  end

  describe "GET index" do
    it "assigns all experiences as @experiences" do
      get :index
      assigns(:experiences).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end

    it "debe mostrar las experiences desde que se publican" do
      get :index
      assigns(:experiences).order(:id).should eq([@experience1, @experience2, @experience3, @experience5, @experience6, @experience7])
      response.should be_success
      response.should render_template("index")
    end

    it "debe generar una excepcion al no poder acceder a la acción" do
      @current_user_eco.group = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
      @current_ability = nil
      @current_user_eco.reload

      expect {
        get :index
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
