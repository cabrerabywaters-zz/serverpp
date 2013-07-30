# encoding: utf-8

# Public: Clase manejar las imagenes que sube un usuario ECO a una experiencia,
#         y que son las únicas validas para que los usuario EFI crean sus banners
#         o favoritos.
#
# @public Operation operation() Entrega la operación de la transacción.
#
# @private NilClass update_account_points_balance!() Callback para actualizar los
#                                                    puntos de la cuenta del usuario.
#
class ValidImage < ActiveRecord::Base
  attr_accessible :image,
                  :experience_id

  # La diferencia con la definición anterior es que
  # estos se usan por el administrador de PuntosPoint
  # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
  attr_accessible :image,
                  :experience_id,
                  as: :puntos_point

  belongs_to :experience

  validates_presence_of :experience_id, on: :update

  # Documento adjunto.
  # Mas información en: https://github.com/thoughtbot/paperclip
  has_attached_file :image

  validates_attachment_presence :image
end
