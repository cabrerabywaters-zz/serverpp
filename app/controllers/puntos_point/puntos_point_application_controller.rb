# encoding: utf-8

# Public: Controlador base para las paginas de administración.
#
# @public Ability current_ability() Entrega las habilidades del usuario logeado.
#
class PuntosPoint::PuntosPointApplicationController < ActionController::Base
  before_filter :authenticate_admin!

  protect_from_forgery

  # Internal: Entrega las habilidades del usuario logeado.
  #
  # Retorna una instancia de Ability
  def current_ability
    @current_ability ||= Ability.new(current_admin, :puntos_point)
  end
end
