# encoding: utf-8

# Public: Clase para manejar las categorías que permiten segregar
#         de forma rápida las experiencias.
#
class Category < ActiveRecord::Base
  # Para ordenar alfabeticamente y por defecto las categorias.
  # More information on http://guides.rubyonrails.org/active_record_querying.html#applying-a-default-scope
  default_scope order(:name)

  attr_accessible :name,
                  :icon,
                  :texture_name

  # Las Experiences pertenecen a esta Category
  has_many :experiences, dependent: :destroy

  # Valida la presencia y la unicidad de la columna :name
  validates :name,
            presence: true,
            uniqueness: true

  # Valida la presencia y la unicidad de la columna :texture_name
  validates :texture_name,
            presence: true

  # Documento adjunto, cuando se sube la imagen
  # se redimenciona a la resolución indicada.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :icon,
                    styles: {original: "44x44!"}

  validates_attachment_presence :icon

  # Nombre de las texturas posibles definidas en el CSS.
  # Para consultar textura ver: /app/assets/stylesheets/efi/categories.css.less
  TEXTURES = ['blue', 'green', 'black', 'purple', 'red', 'orange']

  # Public: Returns icon absolute url.
  #
  # style - Style of the icon.
  #
  # Returns icon absolute url.
  def icon_url style = :original
    icon.url(style, timestamp: false)
  end
end
