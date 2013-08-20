# encoding: utf-8

# Public: Controlador encargado manejar las compras de los usuarios de una EFI
#
class Corporative::PurchasesController < Corporative::CorporativeApplicationController
  # GET /empresa/1/purchases/:id
  def show
    @purchase   = Purchase.find(params[:id])
    @event      = @purchase.exchange.event
    @experience = @event.experience
  end

  # GET /empresa/1/events/1/purchases/new
  def new
    all_events = @corporative.events.joins(:experience).are_published.started

    unless all_events.exists?(params[:id])
      redirect_to corporative_root_path(@corporative), notice: t('notices.error.not_available', model: Event.model_name.human)
      return
    end

    @event      = all_events.find(params[:id])
    @experience = @event.experience
    @purchase   = Purchase.new rut: session[:rut]
  end

  # POST /empresa/1/events/1/purchases
  def create
    all_events = @corporative.events.joins(:experience).are_published.started

    unless all_events.exists?(params[:id])
      redirect_to corporative_root_path(@corporative), notice: t('notices.error.not_available', model: Event.model_name.human)
      return
    end

    @purchase   = Purchase.new params[:purchase]
    @event      = all_events.find(params[:id])
    @experience = @event.experience


    # Flow explanation:
    # 1) Se verifica que los datos del usuario sean validos
    #
    # 2) Se consumen los puntos del usuario
    #
    # 3) Se guarda la transacción
    #
    # 4) Se envía el voucher por email
    #
    # 5) Se muestra la vista de éxito en la compra (:show)
    if @purchase.valid?
      if @corporative.get_connector(rut: @purchase.rut, password: @purchase.password, points: @purchase.exchange.points).spend_points
        @purchase.save

        PurchaseMailer.voucher(@purchase).deliver

        redirect_to corporative_purchase_path(@purchase.id, corporative_id: @corporative.search_name), notice: t('notices.success.female.made', model: Purchase.model_name.human)
      else
        flash[:error] = t('notices.error.has_no_points')
        render :new
      end
    elsif @purchase.errors[:base].any?
      # La Experiencia no tiene canjes disponibles según las condiciones del evento
      flash[:error] = @purchase.errors[:base].last
      redirect_to corporative_root_path(@corporative)
    else
      render :new
    end

  end
end