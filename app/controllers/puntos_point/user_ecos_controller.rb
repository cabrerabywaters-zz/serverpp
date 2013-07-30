# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de usuario ECO.
#
# @private nil check_eco() Verifica que antes de intentar crear usuarios EFI
#                          debe crearse al menos una EFI.
class PuntosPoint::UserEcosController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  before_filter :check_eco, only: [:new, :create]

  # GET /puntos_point/user_ecos
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/user_ecos/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/user_ecos/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/user_ecos/1/edit
  def edit
  end

  # POST /puntos_point/user_ecos
  def create
    @user_eco = UserEco.new(params[:user_eco], as: :puntos_point)
    respond_to do |format|
      if @user_eco.save
        format.html { redirect_to puntos_point_user_ecos_path, notice: t('notices.success.male.create', model: UserEco.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/user_ecos/1
  def update
    respond_to do |format|
      if params[:user_eco][:password].blank?
        successful_update = @user_eco.update_without_password(params[:user_eco], as: :puntos_point)
      else
        successful_update = @user_eco.update_attributes(params[:user_eco], as: :puntos_point)
      end

      if successful_update
        format.html { redirect_to puntos_point_user_ecos_path, notice: t('notices.success.male.update', model: UserEco.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/user_ecos/1
  def destroy
    @user_eco.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_user_ecos_url }
    end
  end

  private
  # Internal: Verifica que antes de intentar crear usuarios ECO debe crearse al
  #           menos una ECO, de no ser asi es redirigido a la pagina para crear
  #           una ECO.
  #
  # Retorna nil
  def check_eco
    redirect_to puntos_point_small_ecos_path, notice: t('notice.error.no_required_models', model: Eco.model_name.human) unless Eco.any?
  end
end
