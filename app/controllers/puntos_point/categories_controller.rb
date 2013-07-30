# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de Categorías.
#
class PuntosPoint::CategoriesController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource

  # GET /puntos_point/categories
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/categories/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /puntos_point/categories/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /puntos_point/categories/1/edit
  def edit
  end

  # POST /puntos_point/categories
  def create
    respond_to do |format|
      if @category.save
        format.html { redirect_to puntos_point_categories_path, notice: t('notices.success.female.create', model: Category.model_name.human) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /puntos_point/categories/1
  def update
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to puntos_point_categories_path, notice: t('notices.success.female.update', model: Category.model_name.human) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /puntos_point/categories/1
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_categories_url }
    end
  end
end
