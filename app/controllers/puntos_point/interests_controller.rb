# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de intereses (TAGS en la experiencia).
#
class PuntosPoint::InterestsController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource

  # GET /puntos_point/interests
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/interests/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/interests/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/interests/1/edit
  def edit
  end

  # POST /puntos_point/interests
  def create
    respond_to do |format|
      if @interest.save
        format.html { redirect_to puntos_point_interests_path, notice: t('notices.success.female.create', model: Interest.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/interests/1
  def update
    respond_to do |format|
      if @interest.update_attributes(params[:interest])
        format.html { redirect_to puntos_point_interests_path, notice: t('notices.success.female.update', model: Interest.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/interests/1
  def destroy
    @interest.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_interests_url }
    end
  end
end
