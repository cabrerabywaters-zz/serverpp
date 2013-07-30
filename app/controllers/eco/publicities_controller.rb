# encoding: utf-8

# Public: Controlador encargado manejar los comunicados de la EFI.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Eco::PublicitiesController < Eco::EcoApplicationController
  authorize_resource
  before_filter :set_selected_menu

  # GET /efi/publicities
  def index
    @publicities = current_user_eco.eco.publicities

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /efi/publicities/1
  def show
    @publicity = current_user_eco.eco.publicities.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # PUT /eco/publicities/1/accept
  def accept
    @publicity = current_user_eco.eco.publicities.find(params[:id])
    redirect_to eco_publicity_url(@publicity), notice: I18n.t('notices.error.male.no_pending', model: Publicity.model_name.human) and return unless @publicity.pending?

    # Acción para aceptar una publicity
    respond_to do |format|
      if @publicity.update_attributes(params[:publicity], as: :eco) and @publicity.accept!
        format.html { redirect_to eco_publicity_url(@publicity) }
      else
        format.html { render 'show' }
      end
    end
  end

  # PUT /eco/publicities/1/reject
  def reject
    @publicity = current_user_eco.eco.publicities.find(params[:id])
    redirect_to eco_publicity_url(@publicity), notice: I18n.t('notices.error.male.no_pending', model: Publicity.model_name.human) and return unless @publicity.pending?

    # Acción para rechazar una publicity
    respond_to do |format|
      if @publicity.update_attributes(params[:publicity], as: :eco) and @publicity.reject!
        format.html { redirect_to eco_publicity_url(@publicity) }
      else
        @show_modal = true
        format.html { render 'show' }
      end
    end
  end

  private
  # Internal: Selecciona el menú correcto para para todas las acciones del controlador.
  #
  # Retorna una String con la ruta del menu asociado al controlador actual (efi_publicities_path)
  def set_selected_menu
    session[:selected_menu] = efi_publicities_path
  end
end