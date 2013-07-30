# encoding: utf-8

# Public: Controlador encargado manejar los Eventos de las diferentes EFI's.
#
class PuntosPoint::EventsController < PuntosPoint::PuntosPointApplicationController
  load_and_authorize_resource

  # GET /puntos_point/events
  def index
    if params[:efi].presence
      @events = @events.joins(:efi).where('efis.name LIKE :name', name: "%#{params[:efi]}%")
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # PUT /puntos_point/events/1/bill
  def bill
    # Acción para facturar un evento
    respond_to do |format|
      if @event.bill!
        format.html { redirect_to puntos_point_events_path }
      else
        format.html { redirect_to puntos_point_events_path, notice: I18n.t('notices.error.male.cant_bill', model: Event.model_name.human) }
      end
    end
  end

  # PUT /puntos_point/events/1/pay
  def pay
    # Acción para pagar un evento
    respond_to do |format|
      if @event.pay!
        format.html { redirect_to puntos_point_events_path }
      else
        format.html { redirect_to puntos_point_events_path, notice: I18n.t('notices.error.male.cant_pay', model: Event.model_name.human) }
      end
    end
  end

end
