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
