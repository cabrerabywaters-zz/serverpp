# encoding: utf-8

# Public: Controlador genérico de la API.
class Api::BaseController < ActionController::Base
  before_filter :authenticate!
  private

  def authenticate!
    @efi = Efi.find_by_api_password(request.headers["Authentication"])

    if @efi.nil? and not action_name == '_generate_wsdl'
      raise WashOut::Dispatcher::SOAPError, "Unauthorized"
    end
  end
end
