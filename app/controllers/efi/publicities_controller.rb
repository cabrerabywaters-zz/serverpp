# encoding: utf-8

# Public: Controlador encargado manejar los comunicados de la EFI.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Efi::PublicitiesController < Efi::EfiApplicationController
  authorize_resource
  before_filter :set_selected_menu

  # GET /efi/publicities
  def index
    @publicities = current_user_efi.efi.publicities

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /efi/publicities/1
  def show
    @publicity = current_user_efi.efi.publicities.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /efi/publicities/new
  def new
    unless current_user_efi.events.are_taken_or_published.any?
      redirect_to efi_root_path, notice: t('notices.error.not_events')
      return
    end

    @publicity = current_user_efi.efi.publicities.build({event_id: current_user_efi.events.last.id}, as: :efi)
    @events    = current_user_efi.efi.events.joins(experience: :eco).where(ecos: {bigger: true}).are_taken_or_published

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /efi/publicities
  def create
    @publicity = current_user_efi.efi.publicities.build(params[:publicity], as: :efi)

    respond_to do |format|
      if @publicity.save
        format.html { redirect_to efi_publicities_path, notice: t('notices.success.male.create', model: Publicity.model_name.human) }
      else
        @events = current_user_efi.efi.events.joins(experience: :eco).where(ecos: {bigger: true}).are_taken_or_published
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /efi/publicities/1
  def destroy
    @publicity = current_user_efi.efi.publicities.find(params[:id])
    @publicity.destroy

    respond_to do |format|
      format.html { redirect_to efi_publicities_url }
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