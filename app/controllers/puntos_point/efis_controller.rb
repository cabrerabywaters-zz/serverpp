# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de EFI's.
#
class PuntosPoint::EfisController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  # GET /puntos_point/efis
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/efis/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/efis/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/efis/1/edit
  def edit
  end

  # POST /puntos_point/efis
  def create
    @efi = Efi.new(params[:efi], as: :puntos_point)
    respond_to do |format|
      if @efi.save
        format.html { redirect_to puntos_point_efis_path, notice: t('notices.success.female.create', model: Efi.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/efis/1
  def update
    respond_to do |format|
      if @efi.update_attributes(params[:efi], as: :puntos_point)
        format.html { redirect_to puntos_point_efis_path, notice: t('notices.success.female.update', model: Efi.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/efis/1
  def destroy
    @efi.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_efis_url }
    end
  end
end
