# encoding: utf-8

# Public: Controlador encargado manejar las validaciones de vouchers.
#
# @private nil set_selected_menu() Selecciona el menú correcto para para todas
#                                  las acciones del controlador.
#
class Eco::PurchasesController < Eco::EcoApplicationController
  authorize_resource :experience, parent: false

  before_filter :set_selected_menu

  # GET /eco/purchases
  def index
    @experience = current_user_eco.experiences.with_states(:published, :active, :closed).find(params[:id])
    @purchases  = @experience.purchases.are_validated.order('updated_at DESC')

    if session[:validated_purchase]
      @validated_purchase = session.delete(:validated_purchase)
    end

    if session[:status]
      @status = session.delete(:status)
    end
    if session[:message]
      @message = session.delete(:message)
    end

    respond_to do |format|
      format.html
    end
  end

  # POST /eco/purchases/validate
  def validate
    @experience = current_user_eco.experiences.with_states(:published, :active, :closed).find(params[:id])
    @purchase = @experience.purchases.find_by_code(params[:code])

    respond_to do |format|
      if @purchase.nil?
        #format.html { redirect_to eco_experiences_path, flash: { experience_id: @experience.id, type: :error, message: t('notices.error.invalid_code', model: Purchase.model_name.human) } }
        format.json { render json: { type: :error, message: t('notices.error.invalid_code', model: Purchase.model_name.human) }}
      elsif @purchase.validated?
        #format.html { redirect_to eco_experiences_path, flash: { experience_id: @experience.id, type: :error, message: t('notices.error.female.was_validated', model: Purchase.model_name.human) } }
        format.json { render json: { type: :error, message: t('notices.error.female.was_validated', model: Purchase.model_name.human) }}
      elsif @purchase.validate!
        #format.html { redirect_to eco_experiences_path, flash: { experience_id: @experience.id, type: :success, message: t('notices.success.female.validate', model: Purchase.model_name.human) } }
        format.json { render json: { type: :success, message: t('notices.success.female.validate', model: Purchase.model_name.human) }}
      else
        #format.html { redirect_to eco_experiences_path, flash: { experience_id: @experience.id, type: :error, message: t('notices.error.female.cant_validate', model: Purchase.model_name.human) } }
        format.json { render json: { type: :error, message: t('notices.error.female.cant_validate', model: Purchase.model_name.human) }}
      end
    end
  end

  private
  # Internal: Selecciona el menú correcto para para todas las acciones del
  #           controlador.
  #
  # Retorna una String con la ruta a lista de experiencias (eco_experiences_path)
  def set_selected_menu
    session[:selected_menu] = eco_experiences_path
  end
end
