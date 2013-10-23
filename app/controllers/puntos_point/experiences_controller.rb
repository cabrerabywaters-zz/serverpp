# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de experiencias.
#
#
class PuntosPoint::ExperiencesController < PuntosPoint::PuntosPointApplicationController
  # before_filter :format_price, only: [:create, :update]
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  # GET /puntos_point/experiences
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/experiences/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @experience = Experience.new
  end

  def create
    @experience = Experience.new(process_experience_params(params[:experience]), as: :puntos_point)
    Industry.all.each { |industry| @experience.industry_experiences.build(industry_id: industry.id, percentage: industry.percentage) }
    respond_to do |format|
      if @experience.save
        if params[:publish_experience].present?
          if @experience.publish!
            format.html { redirect_to puntos_point_experience_path(@experience) }
            format.json { render json: @experience, location: puntos_point_experience_path(@experience) }
          else
            format.html { render action: :new }
            format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
          end
        else
          format.html do
            if request.xhr?
              render partial: 'eco/experiences/form2', layout: false, locals: { experience: @experience }, location: puntos_point_experience_path(@experience)
            else
              redirect_to edit_puntos_point_experience_path(@experience)
            end
          end
          format.json { render json: @experience, location: puntos_point_experience_path(@experience) }
        end
      else
        format.html { render action: :new }
        format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @experience = Experience.find(params[:id])
  end

  def update
    @experience = Experience.find(params[:id])
    respond_to do |format|
      if @experience.update_attributes(process_experience_params(params[:experience]), as: :puntos_point)
        if params[:publish_experience].present?
          if @experience.publish!
            format.html { redirect_to puntos_point_experience_path(@experience) }
            format.json { render json: @experience }
          else
            format.html { render :edit }
            format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
          end
        else
          format.html do
            if request.xhr?
              render partial: 'eco/experiences/form2', layout: false, locals: { experience: @experience }, location: puntos_point_experience_path(@experience)
            else
              redirect_to edit_puntos_point_experience_path(@experience)
            end
          end
          format.json { render json: @experience }
        end
      else
        format.html { render action: :edit }
        format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puntos_point/experiences/1
  def destroy
    @experience.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_experiences_url }
    end
  end

  # PUT /puntos_point/experiences/1/bill
  def bill
    # Acción para facturar una experiencia
    respond_to do |format|
      if @experience.bill!
        format.html { redirect_to puntos_point_experiences_url }
      else
        format.html { redirect_to puntos_point_experiences_url, notice: I18n.t('notices.error.female.cant_bill', model: Experience.model_name.human) }
      end
    end
  end

  # PUT /puntos_point/experiences/1/pay
  def pay
    # Acción para pagar una experiencia
    respond_to do |format|
      if @experience.pay!
        format.html { redirect_to puntos_point_experiences_url }
      else
        format.html { redirect_to puntos_point_experiences_url, notice: I18n.t('notices.error.female.cant_pay', model: Experience.model_name.human) }
      end
    end
  end

  private

  def process_experience_params(params)
    experience_params = params.dup
    experience_params[:amount] = experience_params[:amount].try(:gsub, '.', '')
    experience_params[:discounted_price] = experience_params[:discounted_price].try(:gsub, '.', '')
    experience_params[:discount_percentage] = experience_params[:discount_percentage].try(:gsub, '.', '')
    experience_params
  end
end
