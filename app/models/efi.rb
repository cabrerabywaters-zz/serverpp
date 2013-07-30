# encoding: utf-8

# Public: Empresas con Capacidad Ociosa (ECO).
#
# @public String full_search_name() Entrega la url del catalogo de la EFI (mini-página)
#
# @public String get_connector({}) Entrega el conector que usa la EFI para
#                                  integrar el sistema de puntos.
#
class Efi < ActiveRecord::Base
  # Modulo para manejar un rut con las reglas de validación chilenas
  # Mas información en: http://rubygems.org/gems/run_cl
  include RunCl::ActAsRun

  # Modulo para manejar rutas más amigables
  # https://rubygems.org/gems/friendly_id
  extend FriendlyId
  # Se usa para manejar los catalogos de las EFI's
  friendly_id :search_name

  attr_accessible :logo,
                  :name,
                  :rut,
                  :industry_ids,
                  :zona,
                  :api_username,
                  :api_password

  # La diferencia con la definición anterior es que
  # estos se usan por el administrador de PuntosPoint
  # Mas información en: http://guides.rubyonrails.org/security.html#countermeasures
  attr_accessible :logo,
                  :name,
                  :rut,
                  :industry_ids,
                  :zona,
                  :search_name,
                  :connector_name,
                  :compared,
                  as: :puntos_point

  has_many :user_efis, dependent: :destroy

  has_many :industry_efis, dependent: :destroy
  has_many :industries, through: :industry_efis

  has_many :experience_efis, dependent: :destroy
  # Las Experiences en las que puede participar la EFI
  has_many :available_experiences, through: :experience_efis, source: :experience


  has_many :accounts, dependent: :destroy

  has_many :events, dependent: :destroy
  has_many :banners,     through: :events
  has_many :publicities, through: :events

  validates_presence_of :name,
                        :zona,
                        :search_name,
                        :connector_name,
                        :industry_efis

  validates_uniqueness_of :search_name

  # Documento adjunto, cuando se sube la imagen
  # se redimenciona a la resolución indicada.
  # Mas información en: https://github.com/thoughtbot/paperclip
  #                     http://www.imagemagick.org
  #                     http://www.imagemagick.org/script/command-line-processing.php#geometry
  has_attached_file :logo,
                    :styles => { :original => "x110", :thumb => "x35" }

  validates_attachment_presence :logo

  # Búsqueda predefinida que permite filtrar/buscar las EFI's que se comparan.
  scope :are_compared, where(compared: true)

  # Valida la presencia y la unicidad de la columna :rut
  validates :rut, presence: true, uniqueness: true

  # Valida el rut según reglas de validación chilenas,
  # validando tanto formato como unicidad.
  # Por otra parte, quita cualquier tipo de formato del rut,
  # de modo que se mantengan los datos consistentes.
  # Mas información en: http://rubygems.org/gems/run_cl
  has_run_cl :rut

  # Internal: Entrega la url del catalogo de la EFI (mini-página).
  #
  # Ejemplo
  #   a) Para una EFI con search_name: "test"
  #   full_search_name()
  #   # => 'http://puntospoint.com/test'
  # NOTA: Esto es asumiendo que estamos en producción y que ya se esta usando el
  #       dominio puntospoint.com y no la IP de QA
  #
  # Retorna una String con la url del catalogo de la EFI
  def full_search_name
    Settings.url + search_name
  end

  # Internal: Entrega el conector que usa la EFI para integrar el sistema de puntos.
  #           Puede propocionarse los parametros que correspondan segun la
  #           transacción que se requiera.
  #
  # Ejemplo
  #   a) Para consultar puntos de una efi con:
  #     - id: 1
  #     - que usa el conector base
  #   get_connector(rut: '12.345.678-5')
  #   # => #<BaseConnector:0x007fa1df66cf28 @rut: '12.345.678-5',
  #                                         @efi_id: 1>
  #
  #   b) Para consumir puntos de una efi con:
  #     - id: 1
  #     - que usa el conector base
  #   get_connector(rut: '12.345.678-5', password: '********', points: 100)
  #   # => #<BaseConnector:0x007fa1df66cf28 @rut: '12.345.678-5',
  #                                         @password: '********',
  #                                         @points: 100,
  #                                         @efi_id: 1>
  #
  # NOTA: Esto es asumiendo que estamos en producción y que ya se esta usando el
  #       dominio puntospoint.com y no la IP de QA
  #
  # Retorna una instancia de un Connector (ej: BaseConnector)
  def get_connector options={}
    connector_class = connector_name.classify.constantize
    connector_class.new options.merge({:efi_id => self.id})
  end
end
