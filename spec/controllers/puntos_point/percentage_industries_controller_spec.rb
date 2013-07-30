require 'spec_helper'

describe PuntosPoint::PercentageIndustriesController do
  login_admin

  before :each do
    @industry1 = FactoryGirl.create(:industry, percentage: 50)
    @industry2 = FactoryGirl.create(:industry, percentage: 50)
    @industry3 = FactoryGirl.create(:industry, percentage:  0)
  end

  describe "GET edit" do
    it "assigns all industries as @industries" do
      get :edit
      assigns(:industries).should_not be_nil
      response.should be_success
      response.should render_template("edit")
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "El porcentaje global debe ser 100%" do
        put :update, industries: {@industry1.id.to_s => {"percentage"=>"10.0"},
                                  @industry2.id.to_s => {"percentage"=>"20.0"},
                                  @industry3.id.to_s => {"percentage"=>"70.0"}}
        Industry.sum(:percentage).should eq 100.0
      end

      it "assigns the requested industry as @industry" do
        put :update, industries: {@industry1.id.to_s => {"percentage"=>"10.0"},
                                  @industry2.id.to_s => {"percentage"=>"20.0"},
                                  @industry3.id.to_s => {"percentage"=>"70.0"}}
        assigns(:industries).should eq [@industry1, @industry2, @industry3]
      end

      context "cuando disminuyo los porcentajes existentes para el nuevo" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"10.0"},
                                    @industry2.id.to_s => {"percentage"=>"20.0"},
                                    @industry3.id.to_s => {"percentage"=>"70.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando disminuyo solo el segundo porcentaje para el nuevo" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"50.0"},
                                    @industry2.id.to_s => {"percentage"=>"10.0"},
                                    @industry3.id.to_s => {"percentage"=>"40.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando aumento el primer porcentaje" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"60.0"},
                                    @industry2.id.to_s => {"percentage"=>"40.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando aumento el segundo porcentaje" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"40.0"},
                                    @industry2.id.to_s => {"percentage"=>"60.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando las primera industria tiene el porcentaje total" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"100.0"},
                                    @industry2.id.to_s => {"percentage"=>"0.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando las segunda industria tiene el porcentaje total" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"0.0"},
                                    @industry2.id.to_s => {"percentage"=>"100.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end

      context "cuando las nueva industria tiene el porcentaje total" do
        it "redirects to the industries path" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"0.0"},
                                    @industry2.id.to_s => {"percentage"=>"0.0"},
                                    @industry3.id.to_s => {"percentage"=>"100.0"}}
          response.should redirect_to(puntos_point_industries_path)
        end
      end
    end

    describe "with invalid params" do
    #   it "assigns the industry as @industry" do
    #     put :update, id: @industry, industry:  { name: "" }
    #     assigns(:industry).should eq(@industry)
    #   end

      context "cuando no se completa el 100%" do
        it "re-renders the 'edit' template" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"10.0"},
                                    @industry2.id.to_s => {"percentage"=>"0.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          response.should render_template("edit")
        end
        it "El porcentaje global debe ser 100%" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"10.0"},
                                    @industry2.id.to_s => {"percentage"=>"0.0"},
                                    @industry3.id.to_s => {"percentage"=>"0.0"}}
          Industry.sum(:percentage).should eq 100.0
        end
      end

      context "cuando todas las industrias tiene el 100% asignado" do
        it "re-renders the 'edit' template" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"100.0"},
                                    @industry2.id.to_s => {"percentage"=>"100.0"},
                                    @industry3.id.to_s => {"percentage"=>"100.0"}}
          response.should render_template("edit")
        end
        it "El porcentaje global debe ser 100%" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"100.0"},
                                    @industry2.id.to_s => {"percentage"=>"100.0"},
                                    @industry3.id.to_s => {"percentage"=>"100.0"}}
          Industry.sum(:percentage).should eq 100.0
        end
      end

      context "cuando se excede por poco el 100%" do
        it "re-renders the 'edit' template" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"50.0"},
                                    @industry2.id.to_s => {"percentage"=>"50.0"},
                                    @industry3.id.to_s => {"percentage"=>"1.0"}}
          response.should render_template("edit")
        end
        it "El porcentaje global debe ser 100%" do
          put :update, industries: {@industry1.id.to_s => {"percentage"=>"50.0"},
                                    @industry2.id.to_s => {"percentage"=>"50.0"},
                                    @industry3.id.to_s => {"percentage"=>"1.0"}}
          Industry.sum(:percentage).should eq 100.0
        end
      end
    end
  end

end
