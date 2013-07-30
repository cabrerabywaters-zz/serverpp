# encoding: utf-8

# Public: Controlador base para las paginas de administración de los usuario EFI.
#
# @public Ability current_ability() Entrega las habilidades del usuario logeado.
#
# @private String restore_selected_menu() Des-selecciona los menús, para que cada
#                                         acción pueda encargarse solo de setear
#                                         el menú que le corresponda.
#
# @private Array load_categories() Carga todas las categorías para ser usadas como filtro.
#
class Efi::EfiApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user_efi!


  before_filter :restore_selected_menu
  before_filter :load_categories

  # Internal: Entrega las habilidades del usuario logeado.
  #
  # Retorna una instancia de Ability
  def current_ability
    @current_ability ||= Ability.new(current_user_efi, :efi)
  end

  private
  # Internal: Des-selecciona los menús, para que cada acción pueda encargarse
  #           solo de setear el menú que le corresponda.
  #
  # Retorna una String vacio ('')
  def restore_selected_menu
    session[:selected_menu] = ''
    session[:selected_efi_menu] = ''
  end

  # Internal: Carga todas las categorías para ser usadas como filtro.
  #
  # Retorna Array con todas las categorías
  def load_categories
    @categories = Category.all
  end
end
