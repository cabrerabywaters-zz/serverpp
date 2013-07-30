# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de industrias.
#
class PuntosPoint::IndustriesController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource

  # GET /puntos_point/industries
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/industries/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/industries/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/industries/1/edit
  def edit
  end

  # POST /puntos_point/industries
  def create
    respond_to do |format|
      if @industry.save
        format.html { redirect_to puntos_point_industries_path, notice: t('notices.success.male.create', model: Industry.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/industries/1
  def update
    respond_to do |format|
      if @industry.update_attributes(params[:industry])
        format.html { redirect_to puntos_point_industries_path, notice: t('notices.success.male.update', model: Industry.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/industries/1
  def destroy
    if @industry.percentage > 0.0 and Industry.count > 1
      redirect_to puntos_point_edit_percentage_industries_path, notice: t('notices.error.industry_percentage')
      return
    end

    @industry.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_industries_url }
    end
  end
end
