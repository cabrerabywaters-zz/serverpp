# encoding: utf-8
require 'spec_helper'

describe PuntosPoint::ExperienceStepsController do
  login_admin

  before :each do
    @industry1 = FactoryGirl.create(:industry)
    @industry2 = FactoryGirl.create(:industry)

    @eco         = FactoryGirl.create(:eco)
    @experience  = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'pending')

    @experience.industry_experiences.destroy_all
    FactoryGirl.create(:industry_experience, experience_id: @experience.id, industry_id: @industry1.id, percentage: 50.0)
    FactoryGirl.create(:industry_experience, experience_id: @experience.id, industry_id: @industry2.id, percentage: 50.0)
    @experience.reload
    @experience.industry_experiences.reload

    image = ActionDispatch::Http::UploadedFile.new( { filename: 'experience.jpg',
                                                      type: 'image/jpg',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/experience.jpg')  })
    comuna   = FactoryGirl.create(:comuna)
    efi      = FactoryGirl.create(:efi)
    category = FactoryGirl.create(:category)
    interest = FactoryGirl.create(:interest)

    @codes = ActionDispatch::Http::UploadedFile.new( { filename: 'codes.xlsx',
                                                      # type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                      tempfile: File.new(Rails.root + 'spec/fixtures/experiences/codes.xlsx')  })

    @valid_attributes_step1 = { 'eco_id' => @eco.id.to_s,
                                'name' => 'Experience Test',
                                'validity_starting_at' => (Date.current + 1.day).to_s,
                                'validity_ending_at' => (Date.current + 10.day).to_s,
                                'swaps' => '1',
                                'place' => 'Estadio falso',
                                'chilean_cities_comuna_id' => comuna.id.to_s,
                                'image' => image,
                                'details' => '<p>hola</p>',
                                'conditions' => '<p>Solo mayores de 18</p>',
                                'exchange_mechanism' => '<p>Con carne en mano</p>' }

    @valid_attributes_step2 = { 'amount' => '1000',
                                'discounted_price' => '900',
                                'available_efi_ids' => [efi.id.to_s],
                                'valid_images_attributes' => {'0' => {image: image}},
                                'summary' => 'Experience summary' }

    @valid_attributes_step3 = { 'category_id' => category.id.to_s,
                                'interest_ids' => [interest.id.to_s],
                                'starting_at' => (Date.current).to_s,
                                'ending_at' => (Date.current + 10.day).to_s,
                                'industry_experiences_attributes' => [{'industry_id' => @industry1.id.to_s, 'percentage' => '10.0'},
                                                                      {'industry_id' => @industry2.id.to_s, 'percentage' => '90.0'}],
                                'fee' => @eco.fee.to_s,
                                'total_exclusivity_days' => '1',
                                'by_industry_exclusivity_days' => '1' }
  end

  describe "GET index" do
    context "in order to create a new experience" do
      it "redirects to the wizzard" do
        get :index
        response.should redirect_to(puntos_point_experience_step_path(:step1))
      end

      it "unset session id" do
        session[:experience_id].should be_nil
        get :index
        session[:experience_id].should be_nil
      end
    end

    context "in order to update a existing experience" do
      it "redirects to the wizzard on experience state" do
        experience  = FactoryGirl.create(:experience, state: 'step2')

        get :index, experience_id: experience.id
        response.should redirect_to(puntos_point_experience_step_path(:step2))
      end

      it "redirects to the wizzard on first step for pending experience" do
        @experience.state.should eq('pending')
        get :index, experience_id: @experience.id
        response.should redirect_to(puntos_point_experience_step_path(:step1))
      end

      it "set session id" do
        session[:experience_id].should be_nil
        get :index, experience_id: @experience.id
        session[:experience_id].should_not be_nil
      end
    end
  end

  describe "GET show" do
    context "in order to create a new experience" do
      it "renderea el template correcto" do
        session[:experience_id].should be_nil
        get :show, id: :step1
        response.should render_template("step1")
      end

      it "no me puedo saltar el step1" do
        session[:experience_id].should be_nil
        get :show, id: :step2
        response.should redirect_to(puntos_point_experience_step_path(:step1))
      end

      it "debe construir una experience nueva" do
        session[:experience_id].should be_nil
        get :show, id: :step1
        assigns(:experience).should be_a_new(Experience)
      end
    end

    context "in order to update a existing experience" do
      it "set warning if experience cant be updated" do
        experience2 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
        session[:experience_id] = experience2.id
        get :show, id: :step1
        flash[:notice].should_not be_nil
      end

      describe "renderea el template correcto" do
        it "when experience is on step1" do
          experience  = FactoryGirl.create(:experience, state: 'step1')
          session[:experience_id] = experience.id
          get :show, id: :step1
          response.should render_template("step1")
        end

        it "when experience is on step2" do
          experience  = FactoryGirl.create(:experience, state: 'step2')
          session[:experience_id] = experience.id
          get :show, id: :step2
          response.should render_template("step2")
        end

        it "when experience is on step3" do
          experience  = FactoryGirl.create(:experience, state: 'step3')
          session[:experience_id] = experience.id
          get :show, id: :step3
          response.should render_template("step3")
        end

        it "when experience is on pending and required incorrect step" do
          session[:experience_id] = @experience.id
          get :show, id: :pending
          response.should redirect_to(puntos_point_experiences_path)
        end

        it "when experience is on pending and required correct step" do
          session[:experience_id] = @experience.id
          get :show, id: :step1
          response.should render_template("step1")
        end
      end

      it "debe cargar una experience segun id almacenado en sesion" do
        session[:experience_id] = @experience.id
        get :show, id: :step1
        assigns(:experience).should be_a(Experience)
        assigns(:experience).should be_persisted
        assigns(:experience).should eq(@experience)
      end

      it "debe cargar una experience segun id almacenado en sesion" do
        session[:experience_id] = @experience.id
        get :show, id: :step1
        assigns(:experience).should be_a(Experience)
        assigns(:experience).should be_persisted
        assigns(:experience).should eq(@experience)
      end

      it "debe preseleccionar todas las efi" do
        session[:experience_id] = @experience.id
        get :show, id: :step2
        assigns(:experience).available_efi_ids.should_not be_empty
      end

      it "debe construir valid_images" do
        session[:experience_id] = @experience.id
        get :show, id: :step2
        assigns(:experience).valid_images.should_not be_empty
      end

      it "debe preseleccionar todas las exclusividades por defecto" do
        session[:experience_id] = @experience.id

        @experience.total_exclusivity_sales = nil
        @experience.by_industry_exclusivity_sales = nil
        @experience.without_exclusivity_sales = nil
        @experience.state = 'step2'
        @experience.save!

        @experience.total_exclusivity_sales.should be_nil
        @experience.by_industry_exclusivity_sales.should be_nil
        @experience.without_exclusivity_sales.should be_nil

        get :show, id: :step2

        assigns(:experience).total_exclusivity_sales.should_not be_nil
        assigns(:experience).by_industry_exclusivity_sales.should_not be_nil
        assigns(:experience).without_exclusivity_sales.should_not be_nil
      end

      it "no debe modificar la seleccion de las exclusividades" do
        session[:experience_id] = @experience.id

        @experience.total_exclusivity_sales = false
        @experience.by_industry_exclusivity_sales = true
        @experience.without_exclusivity_sales = false
        @experience.state = 'step2'
        @experience.save!

        @experience.total_exclusivity_sales.should be_false
        @experience.by_industry_exclusivity_sales.should be_true
        @experience.without_exclusivity_sales.should be_false

        get :show, id: :step2

        assigns(:experience).total_exclusivity_sales.should be_false
        assigns(:experience).by_industry_exclusivity_sales.should be_true
        assigns(:experience).without_exclusivity_sales.should be_false
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      context "in order to create a new experience" do
        it "no me puedo saltar el step1 e ir directo al step 2" do
          session[:experience_id].should be_nil
          put :update, id: :step2, experience: @valid_attributes_step1
          response.should redirect_to(puntos_point_experience_step_path(:step1))
        end

        it "no me puedo saltar el step1 e ir directo al step 3" do
          session[:experience_id].should be_nil
          put :update, id: :step3, experience: @valid_attributes_step1
          response.should redirect_to(puntos_point_experience_step_path(:step1))
        end

        it "debe guardar la experience" do
          session[:experience_id].should be_nil
          expect {
            put :update, id: :step1, experience: @valid_attributes_step1
          }.to change(Experience, :count).by(1)
        end

        it "debe ir al siguiente paso" do
          session[:experience_id].should be_nil
          put :update, id: :step1, experience: @valid_attributes_step1
          response.should redirect_to(puntos_point_experience_step_path(:step2))
        end
      end

      context "in order to update a existing experience" do
        it "debe cargar una experience segun id almacenado en sesion" do
          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: @valid_attributes_step2
          assigns(:experience).should be_a(Experience)
          assigns(:experience).should be_persisted
          assigns(:experience).should eq(@experience)
        end

        it "debe ir al siguiente paso" do
          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: @valid_attributes_step2
          response.should redirect_to(puntos_point_experience_step_path(:step3))
        end

        it "debe ir al paso final" do
          session[:experience_id] = @experience.id
          @experience.industry_experiences.destroy_all

          put :update, id: :step3, experience: @valid_attributes_step3
          response.should redirect_to(puntos_point_experience_step_path(:wicked_finish))
        end

        it "update a Experience with formated prices" do
          valid_attributes2 = @valid_attributes_step2.clone
          valid_attributes2['amount'] = '10.000'
          valid_attributes2['discounted_price'] = '9.000'

          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: valid_attributes2
          response.should redirect_to(puntos_point_experience_step_path(:step3))

          assigns(:experience).amount.should eq(10000)
          assigns(:experience).discounted_price.should eq(9000)
        end

        it "update a Experience with discount_percentage" do
          valid_attributes2 = @valid_attributes_step2.clone
          valid_attributes2.delete('discounted_price')
          valid_attributes2['discount_percentage'] = '40'
          valid_attributes2['amount'] = '100'
          valid_attributes2['discounted_price'] = ''

          @experience.discounted_price.should_not eq(60)

          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: valid_attributes2
          response.should redirect_to(puntos_point_experience_step_path(:step3))

          assigns(:experience).discounted_price.should eq(60)
          assigns(:experience).amount.should eq(100)
        end

        it "file with codes" do
          valid_attributes2 = @valid_attributes_step2.clone
          valid_attributes2['file_codes'] = @codes
          valid_attributes2['swaps'] = '6'
          valid_attributes2['codes_by_purchase'] = '1'

          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: valid_attributes2
          response.should redirect_to(puntos_point_experience_step_path(:step3))
        end

        it "la eco debe poder subir imagenes validas para publicidad" do
          session[:experience_id] = @experience.id
          put :update, id: :step2, experience: @valid_attributes_step2

          assigns(:experience).valid_images.should_not be_empty
        end

        it "debe considerar los medios de comunicación si es una eco chica" do
          session[:experience_id] = @experience.id
          @eco.bigger = false
          @eco.save!
          put :update, id: :step2, experience:  { advertising_ids: [FactoryGirl.create(:advertising).id.to_s] }
          assigns(:experience).advertisings.should_not be_empty
        end

        it "debe considerar los medios de comunicación si es una eco grande" do
          session[:experience_id] = @experience.id
          @eco.bigger = true
          @eco.save!
          put :update, id: :step2, experience:  { advertising_ids: [FactoryGirl.create(:advertising).id.to_s] }
          assigns(:experience).advertisings.should_not be_empty
        end

        it "debe considerar las exclusividades si es una eco chica" do
          session[:experience_id] = @experience.id
          @eco.bigger = true
          @eco.save!
          put :update, id: :step2, experience:  { 'total_exclusivity_sales' => 'true',
                                                  'by_industry_exclusivity_sales' => 'true',
                                                  'without_exclusivity_sales' => 'true' }
          assigns(:experience).total_exclusivity_sales.should be_true
          assigns(:experience).by_industry_exclusivity_sales.should be_true
          assigns(:experience).without_exclusivity_sales.should be_true
        end

        it "debe considerar las exclusividades si es una eco grande" do
          session[:experience_id] = @experience.id
          @eco.bigger = false
          @eco.save
          put :update, id: :step2, experience:  { 'total_exclusivity_sales' => 'true',
                                                  'by_industry_exclusivity_sales' => 'true',
                                                  'without_exclusivity_sales' => 'true' }
          assigns(:experience).total_exclusivity_sales.should be_true
          assigns(:experience).by_industry_exclusivity_sales.should be_true
          assigns(:experience).without_exclusivity_sales.should be_true
        end
      end
    end

    describe "with invalid params" do
      it "re-renders the 'step3' template" do
        session[:experience_id] = @experience.id
        put :update, id: :step3, experience:  { fee: "" }
        response.should render_template("step3")
      end

      it "assigns the experience as @experience" do
        session[:experience_id] = @experience.id
        put :update, id: :step1, experience:  { name: "" }
        assigns(:experience).should eq(@experience)
      end

      it "no debe guardar si faltan datos" do
        expect {
          put :update, id: :step1, experience: { name: "" }
        }.to change(Experience, :count).by(0)
      end

      it "re-renders the 'step1' template" do
        session[:experience_id] = @experience.id
        put :update, id: :step1, experience:  { name: "" }
        response.should render_template("step1")
      end

      it "re-renders the 'step2' template" do
        session[:experience_id] = @experience.id
        put :update, id: :step2, experience:  { name: "" }
        response.should render_template("step2")
      end

      it "set warning if experience cant be updated, requiring step1" do
        experience2 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
        session[:experience_id] = experience2.id
        put :update, id: :step1, experience:  @valid_attributes_step1
        flash[:notice].should_not be_nil
      end

      it "set warning if experience cant be updated, requiring step2" do
        experience2 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
        session[:experience_id] = experience2.id
        put :update, id: :step2, experience:  @valid_attributes_step2
        flash[:notice].should_not be_nil
      end

      it "set warning if experience cant be updated, requiring step3" do
        experience2 = FactoryGirl.create(:experience, eco_id: @eco.id, state: 'published')
        session[:experience_id] = experience2.id
        put :update, id: :step3, experience: @valid_attributes_step3
        flash[:notice].should_not be_nil
      end
    end
  end

end
