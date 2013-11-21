# encoding: utf-8

# Public: Controlador encargado manejar las experiencias de los usuarios de una ECO.
#
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Eco::ExperiencesController < Eco::EcoApplicationController
  load_and_authorize_resource

  before_filter :set_selected_menu

  # GET /eco/experiences
  def index
    @experiences = current_user_eco.experiences.active.ordered
    @experience_drafts = current_user_eco.experiences.draft.ordered
    @published_experiences = current_user_eco.experiences.published.ordered
    @expired_experiences = current_user_eco.experiences.expired.ordered
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /eco/experiences/1
  def show
    @purchases = @experience.purchases

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @experience = current_user_eco.eco.experiences.new
  end

  def create
    experience_params = process_experience_params(params[:experience])
    @experience = current_user_eco.eco.experiences.new(experience_params)
    respond_to do |format|
      if @experience.save(as: :eco)
        format.html do
          if request.xhr?
            render partial: 'form2', layout: false, locals: { experience: @experience }, location: eco_experience_path(@experience)
          else
            redirect_to edit_eco_experience_path(@experience)
          end
        end
        format.json { render json: @experience, location: eco_experience_path(@experience) }
      else
        format.html { render action: :new }
        format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @experience = current_user_eco.eco.experiences.find(params[:id])
  end

  def update
    experience_params = process_experience_params(params[:experience])
    @experience = current_user_eco.eco.experiences.find(params[:id])
    respond_to do |format|
      if @experience.update_attributes(experience_params)
        format.html do
          if request.xhr?
            render partial: 'form2', layout: false, locals: { experience: @experience }, location: eco_experience_path(@experience)
          else
            redirect_to edit_eco_experience_path(@experience)
          end
        end
        format.json { render json: @experience }
      else
        format.html { render action: :edit }
        format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eco/experiences/1
  def destroy
    # Revisa que antes de eliminar la experience, esta debe estar en estado pendiente.
    unless @experience.draft?
      redirect_to eco_experiences_path, notice: t('notices.error.not_pending', model: Experience.model_name.human)
      return
    end

    @experience.destroy

    session[:experience_id] = nil

    respond_to do |format|
      format.html { redirect_to eco_experiences_url }
    end
  end

  private
  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta a lista de experiencias (eco_experiences_path)
  def set_selected_menu
    session[:selected_menu] = eco_experiences_path
  end

  private

  def process_experience_params(params)
    experience_params = params.dup
    experience_params[:amount] = experience_params[:amount].try(:delete, ',')
    experience_params[:discounted_price] = experience_params[:discounted_price].try(:delete, ',')
    experience_params[:discount_percentage] = experience_params[:discount_percentage].try(:delete, ',')
    experience_params
  end
end
