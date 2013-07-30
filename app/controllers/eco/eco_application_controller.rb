# encoding: utf-8

# Public: Controlador base para las paginas de administración de los usuario ECO.
#
# @public Ability current_ability() Entrega las habilidades del usuario logeado.
#
# @private String restore_selected_menu() Des-selecciona los menús, para que cada
#                                      acción pueda encargarse solo de setear el
#                                      menú que le corresponda.
#
class Eco::EcoApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user_eco!
  before_filter :restore_selected_menu

  # Internal: Entrega las habilidades del usuario logeado.
  #
  # Retorna una instancia de Ability
  def current_ability
    @current_ability ||= Ability.new(current_user_eco, :eco)
  end

  private
  # Internal: Des-selecciona los menús, para que cada acción pueda encargarse
  #           solo de setear el menú que le corresponda.
  #
  # Retorna una String vacio ('')
  def restore_selected_menu
    session[:selected_menu] = ''
  end
end
