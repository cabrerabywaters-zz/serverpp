# encoding: utf-8

# Public: Clase para manejar los banner de las diferentes EFI's.
#
class Banner < ActiveRecord::Base
  belongs_to :event

  attr_accessible :image,
                  :published,
                  :event_id

  validates_presence_of :event_id

  # Documento adjunto, cuando se sube la imagen
  # se redimenciona a la resolución indicada.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :image,
                    styles: {original: "1170x308!"}

  validates_attachment_presence :image

  # Búsqueda predefinida que permite filtrar/buscar los banners que estén publicados.
  scope :published, where(published: true)
end
