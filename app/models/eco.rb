# encoding: utf-8

# Public: Empresas con Capacidad Ociosa (ECO).
#
# @private (String|NilClass) set_webpage!() Agrega por defecto el prefijo para
#                                           paginas web (http://www.)
#
class Eco < ActiveRecord::Base
  # Modulo para manejar un rut con las reglas de validación chilenas
  # Mas información en: http://rubygems.org/gems/run_cl
  include RunCl::ActAsRun

  attr_accessible :logo,
                  :name,
                  :rut,
                  :webpage

  # La diferencia con la definición anterior es que
  # estos se usan por el administrador de PuntosPoint
  # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
  attr_accessible :logo,
                  :name,
                  :rut,
                  :webpage,
                  :images,
                  :fancy_name,
                  :address,
                  :discount,
                  :fee,
                  :comuna_id,
                  :admin_id,
                  :description,
                  as: :puntos_point

  has_many :experiences, dependent: :destroy
  has_many :events,      through: :experiences
  has_many :publicities, through: :events
  has_many :invoices

  has_many :user_ecos,   dependent: :destroy

  belongs_to :comuna, class_name: ChileanCities::Comuna, foreign_key: :comuna_id

  belongs_to :admin

  validates_presence_of :fancy_name,
                        :address,
                        :discount,
                        :fee,
                        :comuna_id,
                        :admin_id

  validates_numericality_of :discount,
                            greater_than_or_equal_to: 0,
                            less_than: 100

  validates_numericality_of :fee,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100

  # Valida la presencia y la unicidad de la columna :name
  validates :name,    presence: true, uniqueness: true

  # Valida la presencia de la columna :webpage
  validates :webpage, presence: true

  # Valida el formato de URL para la columna :webpage
  validates_format_of :webpage, with: URI::regexp(%w(http https))

  # Documento adjunto, cuando se sube la imagen
  # se redimenciona a la resolución indicada.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :logo,
                    :styles => { :original => "x110", :thumb => "x35" }

  validates_attachment_presence :logo

  # Valida que el campo bigger este correcto
  validates :bigger, inclusion: {in: [true, false]}

  # Valida la presencia y la unicidad de la columna :rut
  validates  :rut, presence: true, uniqueness: true

  # Valida el rut según reglas de validación chilenas,
  # validando tanto formato como unicidad.
  # Por otra parte, quita cualquier tipo de formato del rut,
  # de modo que se mantengan los datos consistentes.
  # Mas información en: http://rubygems.org/gems/run_cl
  has_run_cl :rut

  # Se delega el método :name a la Comuna asocida, permitiendo acceder al
  # método comuna_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.comuna.name
  delegate :name, to: :comuna, prefix: true

  # Se delega el método :name al Administrador asocido, permitiendo acceder al
  # método admin_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.admin.name
  delegate :name, to: :admin, prefix: true

  # Búsqueda predefinida que permite filtrar/buscar ECO's grandes.
  scope :big,   where(bigger: true)

  # Búsqueda predefinida que permite filtrar/buscar ECO's chicas.
  scope :small, where(bigger: false)

  after_initialize :set_webpage!

  # Public: Returns logo absolute url.
  #
  # style - Style of the logo.
  #
  # Returns logo absolute url.
  def logo_url style = :original
    logo.url(style, timestamp: false)
  end

  private
  # Internal: Agrega por defecto el prefijo para paginas web (http://www.),
  #           modificando la columan :webpage de ser necesario.
  #           Si la columna tiene un valor previo, este se mantiene.
  #
  # Ejemplo
  #   a) Para una ECO nueva:
  #     set_webpage!
  #     # => 'http://www.'
  #
  #
  #   b) Para una ECO con webpage: www.test.cl
  #     set_webpage!
  #     # => nil
  #
  # Retorna un String con el valor seteado en la columna (prefijo para paginas web),
  #         o NilClass en caso de que no se modifique la columna :points.
  def set_webpage!
    self.webpage = 'http://www.' unless self.webpage
  end
end
