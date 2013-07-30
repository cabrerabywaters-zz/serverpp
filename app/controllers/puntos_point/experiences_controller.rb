# encoding: utf-8

# Public: Controlador encargado manejar el CRUD de experiencias.
#
#
class PuntosPoint::ExperiencesController < PuntosPoint::PuntosPointApplicationController
  before_filter :format_price, only: [:create, :update]
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  # GET /puntos_point/experiences
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /puntos_point/experiences/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /puntos_point/experiences/1
  def destroy
    @experience.destroy

    respond_to do |format|
      format.html { redirect_to puntos_point_experiences_url }
    end
  end

  # PUT /puntos_point/experiences/1/bill
  def bill
    # Acción para facturar una experiencia
    respond_to do |format|
      if @experience.bill!
        format.html { redirect_to puntos_point_experiences_url }
      else
        format.html { redirect_to puntos_point_experiences_url, notice: I18n.t('notices.error.female.cant_bill', model: Experience.model_name.human) }
      end
    end
  end

  # PUT /puntos_point/experiences/1/pay
  def pay
    # Acción para pagar una experiencia
    respond_to do |format|
      if @experience.pay!
        format.html { redirect_to puntos_point_experiences_url }
      else
        format.html { redirect_to puntos_point_experiences_url, notice: I18n.t('notices.error.female.cant_pay', model: Experience.model_name.human) }
      end
    end
  end
end
