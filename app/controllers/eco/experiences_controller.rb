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
    @experiences = current_user_eco.experiences.active
    @experience_drafts = current_user_eco.experiences.draft
    @published_experiences = current_user_eco.experiences.published
    @expired_experiences = current_user_eco.experiences.expired
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
    @experience = params[:id].present? ? Experience.find(params[:id]) : current_user_eco.eco.experiences.create
  end

  def update
    @experience = current_user_eco.eco.experiences.find(params[:id])
    respond_to do |format|
      if @experience.update_attributes(params[:experience])
        if params[:publish_experience].present?
          if @experience.publish!
            format.html
            format.json { render json: @experience }
          else
            format.html
            format.json { render json: { errors: @experience.errors }, status: :unprocessable_entity }
          end
        else
          format.html
          format.json { render json: @experience }
        end
      else
        format.html { redirect_to new_eco_experience_path(id: @experience.id) }
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
end
