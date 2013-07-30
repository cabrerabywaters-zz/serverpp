require 'spec_helper'

describe PuntosPoint::IndustriesController do
  login_admin

  before :each do
    @industry1 = FactoryGirl.create(:industry, percentage: 50)
    @industry2 = FactoryGirl.create(:industry, percentage: 50)

    @valid_attributes = { name: 'Super industry de prueba' }
  end

  describe "GET index" do
    it "assigns all industries as @industries" do
      get :index
      assigns(:industries).should_not be_nil
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "GET show" do
    it "assigns the requested industry as @industry" do
      get :show, id: @industry1
      assigns(:industry).should_not be_nil
      response.should be_success
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new industry as @industry" do
      get :new
      assigns(:industry).should be_a_new(Industry)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "assigns the requested industry as @industry" do
      get :edit, id: @industry1
      assigns(:industry).should_not be_nil
      assert_response :success
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Industry" do
        expect {
          post :create, industry: @valid_attributes
        }.to change(Industry, :count).by(1)
      end

      it "assigns a newly created industry as @industry" do
        post :create, industry: @valid_attributes
        assigns(:industry).should be_a(Industry)
        assigns(:industry).should be_persisted
      end

      it "redirects to the created industry" do
        post :create, industry: @valid_attributes
        response.should redirect_to(puntos_point_industries_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved industry as @industry" do
        post :create, industry: { name: "" }
        assigns(:industry).should be_a_new(Industry)
      end

      it "assigns a newly created but unsaved industry as @industry" do
        post :create, industry: { name: "nueva industria", percentage: '100.0' }
        assigns(:industry).should be_a_new(Industry)
      end

      it "re-renders the 'new' template" do
        post :create, industry: { name: "" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested industry" do
        Industry.any_instance.should_receive(:update_attributes).with(@valid_attributes.as_json)
        put :update, id: @industry1, industry: @valid_attributes
      end

      it "assigns the requested industry as @industry" do
        put :update, id: @industry1, industry: @valid_attributes
        assigns(:industry).should eq(@industry1)
      end

      it "redirects to the industry" do
        put :update, id: @industry1, industry: @valid_attributes
        response.should redirect_to(puntos_point_industries_path)
      end
    end

    describe "with invalid params" do
      it "assigns the industry as @industry" do
        put :update, id: @industry1, industry:  { name: "" }
        assigns(:industry).should eq(@industry1)
      end

      context "cuando el porcentaje no concuerda" do
        it "porcentaje global superior a 100%" do
          put :update, id: @industry1, industry: { name: "nueva industria", percentage: '100.0' }
          assigns(:industry).should eq(@industry1)
          Industry.sum(:percentage).should eq 100.0
          render_template 'edit'
        end

        it "porcentaje global inferior a 100%" do
          put :update, id: @industry1, industry: { name: "nueva industria", percentage: '0.0' }
          assigns(:industry).should eq(@industry1)
          # Industry.sum(:percentage).should eq 100.0
          render_template 'edit'
        end
      end

      it "re-renders the 'edit' template" do
        put :update, id: @industry1, industry:  { name: "" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    context "cuando la industry tiene asignado un percentage" do
      it "redirects to the percentages edit view" do
        delete :destroy, id: @industry1
        response.should redirect_to(puntos_point_edit_percentage_industries_path)
      end

      it "debe setear un notice" do
        delete :destroy, id: @industry1
        flash[:notice].should_not be_nil
      end

      it "no debe eliminar la industry" do
        expect {
          delete :destroy, id: @industry1
        }.to_not change(Industry, :count)
      end
    end

    it "destroys the requested industry" do
      industry = FactoryGirl.create(:industry, percentage: 0.0)
      expect {
        delete :destroy, id: industry
      }.to change(Industry, :count).by(-1)
    end

    it "redirects to the industries list" do
      industry = FactoryGirl.create(:industry, percentage: 0.0)
      delete :destroy, id: industry
      response.should redirect_to(puntos_point_industries_url)
    end
  end

end
