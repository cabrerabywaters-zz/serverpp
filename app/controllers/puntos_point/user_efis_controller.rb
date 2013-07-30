# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de usuarios EFI.
#
# @private nil check_efi() Verifica que antes de intentar crear usuarios EFI
#                          debe crearse al menos una EFI.
#
class PuntosPoint::UserEfisController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  before_filter :check_efi, only: [:new, :create]

  # GET /puntos_point/user_efis
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/user_efis/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/user_efis/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/user_efis/1/edit
  def edit
  end

  # POST /puntos_point/user_efis
  def create
    @user_efi = UserEfi.new(params[:user_efi], as: :puntos_point)
    respond_to do |format|
      if @user_efi.save
        format.html { redirect_to puntos_point_user_efis_path, notice: t('notices.success.male.create', model: UserEfi.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/user_efis/1
  def update
    respond_to do |format|
      if params[:user_efi][:password].blank?
        successful_update = @user_efi.update_without_password(params[:user_efi], as: :puntos_point)
      else
        successful_update = @user_efi.update_attributes(params[:user_efi], as: :puntos_point)
      end

      if successful_update
        format.html { redirect_to puntos_point_user_efis_path, notice: t('notices.success.male.update', model: UserEfi.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/user_efis/1
  def destroy
    @user_efi.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_user_efis_url }
    end
  end

  private
  # Internal: Verifica que antes de intentar crear usuarios EFI debe crearse al
  #           menos una EFI, de no ser asi es redirigido a la pagina para crear
  #           una EFI.
  #
  # Retorna nil
  def check_efi
    redirect_to puntos_point_efis_path, notice: t('notice.error.no_required_models', model: Efi.model_name.human) unless Efi.any?
  end
end
