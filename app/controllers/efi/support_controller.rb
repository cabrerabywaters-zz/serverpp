# encoding: utf-8

# Public: Controlador encargado manejar los ingresos de una EFI.
#
class Efi::SupportController < Efi::EfiApplicationController
  authorize_resource :experience, parent: false

  # GET /efi/support
  def index
  end

  def show
    @security_code = ExperienceSecurityCode.includes(purchase: { exchange: {event: [:efi, :experience]} }).where("efis.id =?", current_user_efi.efi.id).where(code: params[:code]).first
    validation_locals = { security_code: @security_code }
    if @security_code.present?
      @purchase = @security_code.purchase
      @experience = @purchase.exchange.event.experience
      validation_locals = { code: @security_code.code, security_code: @security_code, purchase: @purchase, experience: @experience }
    end
    render partial: 'validate', layout: !request.xhr?, locals: validation_locals
  end

end
