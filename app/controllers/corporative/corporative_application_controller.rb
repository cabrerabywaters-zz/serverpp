# encoding: utf-8

# Public: Controlador base para mini-pagina de las EFI.
#
# @private EFI load_corporative() Carga la EFI según el parámetro dado en la ruta.
#
class Corporative::CorporativeApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_corporative

  private
  # Internal: Carga la EFI según el parámetro dado en la ruta.
  #
  # Retorna una instancia de una EFI
  def load_corporative
    @corporative = Efi.find(params[:corporative_id])
  end
end
