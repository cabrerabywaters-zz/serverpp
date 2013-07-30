# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de administradores puntos point.
#
class PuntosPoint::AdminsController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource

  # GET /puntos_point/admins
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/admins/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/admins/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/admins/1/edit
  def edit
  end

  # POST /puntos_point/admins
  def create
    respond_to do |format|
      if @admin.save
        format.html { redirect_to puntos_point_admins_path, notice: t('notices.success.male.create', model: Admin.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/admins/1
  def update
    respond_to do |format|
      if params[:admin][:password].blank?
        successful_update = @admin.update_without_password(params[:admin])
      else
        successful_update = @admin.update_attributes(params[:admin])
      end

      if successful_update
        format.html { redirect_to puntos_point_admins_path, notice: t('notices.success.male.update', model: Admin.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/admins/1
  def destroy
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_admins_url }
    end
  end
end
