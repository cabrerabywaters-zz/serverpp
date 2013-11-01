# encoding: utf-8

# Public: Controlador genérico del sistema. Basicamente utilizado para inicio de sesiones.
#
# @public after_sign_out_path_for(resource_or_scope) Luego de cerrar session redirige al
#                                                    usuario correspondiente al login indicado
#
# @public after_sign_in_path_for(resource_or_scope) Después de entrar a iniciar sessión si el usuario
#                                                   esta logeado lo redirige a la ruta correspondiente
#
class ApplicationController < ActionController::Base
  protect_from_forgery

  # Internal: Luego de cerrar session redirige al usuario correspondiente al login indicado
  #
  # Retorna String
  def after_sign_out_path_for resource_or_scope
    scope_name = Devise::Mapping.find_scope!(resource_or_scope)

    if scope_name == :user_eco
      eco_root_path
    elsif scope_name == :user_efi
      efi_root_path
    elsif scope_name == :admin
      puntos_point_root_path
    else
      'http://puntospoint.com'
    end
  end

  # Internal: Después de entrar a iniciar sessión si el usuario esta logeado lo redirige a la ruta correspondiente
  #
  # Retorna String
  def after_sign_in_path_for resource_or_scope
    scope_name = Devise::Mapping.find_scope!(resource_or_scope)

    if scope_name == :user_eco
      eco_root_path
    elsif scope_name == :user_efi
      efi_root_path
    elsif scope_name == :admin
      puntos_point_root_path
    else
      'http://puntospoint.com'
    end
  end

  def after_sign_in_path_for resource
    if resource.kind_of?(UserEco)
      eco_root_path
    elsif resource.kind_of?(UserEfi)
      if current_user_efi.group?(Settings.admin_efi)
        efi_root_path
      else
        efi_support_path
      end
    elsif resource.kind_of?(Admin)
      puntos_point_root_path
    end
  end
end
