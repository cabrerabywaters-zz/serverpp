# encoding: utf-8

# Public: Controlador encargado manejar los banners de la EFI.
#
# @private Banner|Array load_efi_banners() Carga lo(s) banners(s) de la EFI.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Efi::BannersController < Efi::EfiApplicationController
  before_filter :load_efi_banners
  load_and_authorize_resource except: :new
  authorize_resource only: :new
  before_filter :set_selected_menu

  # GET /efi/banners
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /efi/banners/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /efi/banners/new
  def new
    unless current_user_efi.events.are_taken.any?
      redirect_to efi_root_path, notice: t('notices.error.not_events')
      return
    end

    @banner = Banner.new(event_id: current_user_efi.events.last.id)
    @events = current_user_efi.efi.events.joins(:experience).are_taken

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /efi/banners/1/edit
  def edit
    @events = current_user_efi.efi.events.joins(:experience).are_taken
  end

  # POST /efi/banners
  def create
    respond_to do |format|
      if @banner.save
        format.html { redirect_to efi_banners_path, notice: t('notices.success.male.create', model: Banner.model_name.human) }
      else
        @events = current_user_efi.efi.events.joins(:experience).are_taken
        format.html { render action: "new" }
      end
    end
  end

  # PUT /efi/banners/1
  def update
    respond_to do |format|
      params[:banner].delete(:password) if params[:banner][:password].blank?

      if @banner.update_attributes(params[:banner])
        format.html { redirect_to efi_banners_path, notice: t('notices.success.male.update', model: Banner.model_name.human) }
      else
        @events = current_user_efi.efi.events.joins(:experience).are_taken
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /efi/banners/1
  def destroy
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to efi_banners_url }
    end
  end

  private
  # Internal: Carga lo(s) banners(s) de la EFI.
  #
  # Retorna el(los) banners de la EFI
  def load_efi_banners
    if params[:id].presence
      @banner  = current_user_efi.efi.banners.find(params[:id])
    else
      @banners = current_user_efi.efi.banners
    end
  end

  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta a lista de experiencias (eco_experiences_path)def set_selected_menu
  def set_selected_menu
    session[:selected_menu] = efi_banners_path
  end
end