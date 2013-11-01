# encoding: utf-8

# Public: Experiencias en las que participa una EFI.
#
# @public String translate_state() Permite obtener el estado en que se encuentra
#                                  el evento
#
# @public Boolean in_state?([]) Helper para saber si la experiencia se encuentra
#                               en alguno de los estado dados.
#
# @public String swaps_or_quantity() Entrega la cantidad de reservada o la
#                                    cantidad máxima de canjes del evento.
#
# @public Boolean total_exclusivity?() Indica si un evento tiene la
#                                      'exclusividad total'.
#
# @public Boolean by_industry_exclusivity?() Indica si un evento tiene la
#                                            'exclusividad por industria'.
#
# @public Boolean without_exclusivity?() Indica si un evento es 'sin exclusividad'.
#
# @public String to_s() Entrega una versión de las instancia del evento como String.
#
# @public Exclusivity exclusivity() Entrega la exclusividad del evento.
#
# @public String exclusivity_name() Entrega el nombre de la exclusividad del evento.
#
# @public NilClass check_stock!() Revisa si aun tiene stock disponible o no.
#
# @private NilClass sell_experience!() Callback para indicarle a la experiencia
#                                      asociada que fue tomada.
#
# @private NilClass set_quantity_and_swaps!() Setea por defecto el valor de la
#                                             columna :quantity
#
class Event < ActiveRecord::Base
  attr_accessible :exclusivity_id,
                  :swaps,
                  :efi_id,
                  :experience_id,
                  :exchanges_attributes

  belongs_to :efi

  belongs_to :experience

  has_many   :exchanges, dependent: :destroy
  has_many   :purchases, through: :exchanges

  # Acepta atributos nesteados de los exchanges asociados,
  # rechazando individualmente cada exchange si todos los datos son vacios.
  accepts_nested_attributes_for :exchanges, reject_if: :all_blank

  has_many :banners,     dependent: :destroy
  has_many :publicities, dependent: :destroy

  validates_presence_of :exclusivity_id,
                        :efi_id,
                        :experience_id,
                        :exchanges

  validates_uniqueness_of :efi_id,
                          scope: :experience_id

  # Validador personalizado encargado de validar un evento, este se encarga de
  # las validaciones sobre los evento 'sin exclusividad'.
  # Mas información en: lib/without_exclusivity_validator.rb
  validates_with WithoutExclusivityValidator

  # Validador personalizado encargado de validar un evento, este se encarga de
  # las validaciones sobre el evento en caso de se 'exclusivo por industria'.
  # Mas información en: lib/industry_exclusivity_validator.rb
  validates_with IndustryExclusivityValidator

  # Validador personalizado encargado de validar un evento, este se encarga de
  # las validaciones sobre los evento en con 'exclusividad total'.
  # Mas información en: lib/total_exclusivity_validator.rb
  validates_with TotalExclusivityValidator

  # Validador personalizado encargado de validar un evento, este se encarga de
  # validar que para crear el evento sobre una experiencia, esta deber estar
  # disponible para la efi en cuestion.
  # Mas información en: lib/experience_available_validator.rb
  validates_with ExperienceAvailableValidator

  # Búsqueda predefinida que permite filtrar/buscar los eventos 'con exclusividad total'.
  scope :total_exclusivity,       where(exclusivity_id: Exclusivity.total_id)

  # Búsqueda predefinida que permite filtrar/buscar los eventos 'con exclusividad por industria'.
  scope :exclusivity_by_industry, where(exclusivity_id: Exclusivity.by_industry_id)

  # Búsqueda predefinida que permite filtrar/buscar los eventos 'sin exclusividad'.
  scope :without_exclusivity,     where(exclusivity_id: Exclusivity.without_id)

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén tomados.
  scope :are_taken,               where(state: :taken)

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén tomados o publicados.
  scope :are_taken_or_published,  where(state: [:taken, :published])

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén publicados.
  scope :are_published,           joins(:experience)
                                  .where(experiences: {state: [:published, :active]})
                                  .where(events: {state: :published})

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén cerrados.
  scope :are_closed,              where(state: :closed)

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén facturados.
  scope :are_billed,              where(state: :billed)

  # Búsqueda predefinida que permite filtrar/buscar los eventos que estén pagados.
  scope :are_paid,                where(state: :paid)

  # Búsqueda predefinida que permite filtrar/buscar los eventos cuyas experiencias aun no estan cerradas.
  scope :started, lambda { joins(:experience).where('experiences.starting_at <= :now', now: Date.current) }

  # Se delega el método :swaps a la Experiencia asocida,
  # permitiendo acceder al método experience_swaps()
  # el resultado es el mismo resultado que utilizar:
  #   self.experience.swaps
  delegate :swaps, to: :experience, prefix: true

  # Se delega el método :state a la Experiencia asocida,
  # permitiendo acceder al método experience_state()
  # el resultado es el mismo resultado que utilizar:
  #   self.experience.state
  delegate :state, to: :experience, prefix: true

  # Se delega el método :name a la Experiencia asocida,
  # permitiendo acceder al método experience_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.experience.name
  delegate :name,  to: :experience, prefix: true

  # Se delega el método :logo a la EFI asocida,
  # permitiendo acceder al método efi_logo()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.logo
  delegate :logo,  to: :efi, prefix: true

  # Se delega el método :name a la EFI asocida,
  # permitiendo acceder al método efi_name()
  # el resultado es el mismo resultado que utilizar:
  #   self.efi.name
  delegate :name,  to: :efi, prefix: true

  # Definición de una maquina de estados para el evento, para lo cual se usa la
  # columna :state
  # Mas información en: https://github.com/pluginaweek/state_machine
  state_machine :initial => :published do
    event :publish! do
      transition taken: :published
    end

    event :unpublish! do
      transition published: :taken
    end

    event :close! do
      transition [:taken, :published] => :closed
    end

    event :bill! do
      transition closed: :billed
    end

    event :pay! do
      transition billed: :paid
    end

    state :taken do
    end

    state :published do
    end

    state :closed do
    end

    state :billed do
    end

    state :paid do
    end
  end

  # Internal: Permite obtener el estado en que se encuentra el evento, en un
  #           formato más legible por el usuario final, para esto usa el archivo
  #           de traducciones I18n (http://guides.rubyonrails.org/i18n.html).
  #
  # Retorna un String con contiene el nombre del estado ya traducido.
  def translate_state
    translate = I18n.t('state_machine.event.' + state)
    return translate unless translate.include?('translation missing:')

    return state
  end

  # Public: Helper para saber si la experiencia se encuentra en alguno de los
  #         estado dados.
  #
  # @parametros:
  # Array|String|Symbol states - estado(s) a consultar contra el estado de la experiencia
  #
  # Returns Boolean.
  def in_state?(states)
    if states.class == Array
      states.map{|item| item.to_s}.include? self.state
    elsif states.class == String or states.class == Symbol
      states.to_s == self.state
    else
      nil
    end
  end

  # Internal: Entrega la cantidad de reservada o la cantidad máxima de canjes
  #           del evento, en base a al tipo de exclusivida del evento en cuestion.
  #
  # Ejemplo
  #   a) Para un evento con:
  #       - sin exclusivida
  #       - swaps: 10
  #       - quantity: nil
  #     swaps_or_quantity
  #     # => 10
  #
  #   b) Para un evento con:
  #       - con exclusivida por industria
  #       - swaps: nil
  #       - quantity: 30
  #     swaps_or_quantity
  #     # => 30
  #
  #   b) Para un evento con:
  #       - con exclusivida total
  #       - swaps: nil
  #       - quantity: 100
  #     swaps_or_quantity
  #     # => 100
  #
  # Retorna un Integer que contiene la cantidad de reservada o la cantidad
  #                    máxima de canjes del evento.
  def swaps_or_quantity
    if self.exclusivity_id == Exclusivity.total_id or self.exclusivity_id == Exclusivity.by_industry_id
      quantity || 0
    else
      swaps || 0
    end
  end

  # Internal: Indica si un evento tiene la 'exclusividad total'.
  #
  # Retorna un Boolean.
  def total_exclusivity?
    self.exclusivity_id == Exclusivity.total_id
  end

  # Internal: Indica si un evento tiene la 'exclusividad por industria'.
  #
  # Retorna un Boolean.
  def by_industry_exclusivity?
    self.exclusivity_id == Exclusivity.by_industry_id
  end

  # Internal: Indica si un evento es 'sin exclusividad'.
  #
  # Retorna un Boolean.
  def without_exclusivity?
    self.exclusivity_id == Exclusivity.without_id
  end

  # Internal: Entrega una versión de las instancia del evento como String,
  #           re-definiendo el comportamiento por defecto de la función to_s,
  #           y como resultado entrega el nombre de la experiencia asociada.
  #
  # Retorna un String.
  def to_s
    experience.name
  end

  # Internal: Entrega la exclusividad del evento. Dado que el modelo que maneja
  #           las exclusividades no es un modelo persistido, no es posible acceder
  #           a el con ActiveRecord, esta función es similar a tener el modelo
  #           persistido y usando un belongs_to :exclusivity
  # Ejemplo
  #   a) Para un evento con 'exclusividad total':
  #     full_name
  #     # => #<Exclusivity:0x007fd1e3bc7bb0 @id=1, @name="Exclusividad Total">
  #
  #   b) Para un evento con 'exclusividad por industria':
  #     full_name
  #     # => #<Exclusivity:0x007fd1e3d57db8 @id=2, @name="Exclusividad por Industria">
  #
  #   c) Para un evento 'sin exclusividad':
  #     full_name
  #     # => #<Exclusivity:0x007fd1e3fed500 @id=3, @name="Sin Exclusividad">
  #
  # Retorna una instancia de Exclusivity.
  def exclusivity
    Exclusivity.find exclusivity_id
  end

  # Internal: Entrega el nombre de la exclusividad del evento. Dado que el modelo
  #           que maneja las exclusividades no es un modelo persistido, no es
  #           posible acceder a el con ActiveRecord, esta función es similar a
  #           tener el modelo persistido y usando un "belongs_to :exclusivity" junto
  #           a "delegate :name, to: :experience, prefix: true".
  # Ejemplo
  #   a) Para un evento con 'exclusividad total':
  #     exclusivity_name
  #     # => #<Exclusivity:0x007fd1e3bc7bb0 @id=1, @name="Exclusividad Total">
  #
  #   b) Para un evento con 'exclusividad por industria':
  #     exclusivity_name
  #     # => #<Exclusivity:0x007fd1e3d57db8 @id=2, @name="Exclusividad por Industria">
  #
  #   c) Para un evento 'sin exclusividad':
  #     exclusivity_name
  #     # => #<Exclusivity:0x007fd1e3fed500 @id=3, @name="Sin Exclusividad">
  #
  # Retorna una instancia de Exclusivity.
  def exclusivity_name
    exclusivity.name
  end

  # Internal: Revisa si aun tiene stock disponible o no.
  #           Si ya no tiene stock guarda la fecha de cuando se agoto.
  #           Si aun tiene o vuelve a tener stock disponible eliminando la fecha de cuando se agoto.
  #
  # Retorna nil.
  def check_stock!
    purchase_temp = Purchase.new(exchange_id: self.exchanges.last.id,
                                 rut:         '123456785',
                                 email:       'test@acid.cl',
                                 password:    '12345678')

    if purchase_temp.valid?
      unless self.sold_at.nil?
        self.sold_at = nil
        self.save
      end
    else
      unless self.sold_at.presence
        self.sold_at = DateTime.now
        self.save
      end
    end
  end

  before_validation :set_quantity_and_swaps!
  after_create :sell_experience!
  private
  # Internal: Callback para indicarle a la experiencia asociada que fue tomada.
  #           Con esto se logra el cambio de estado en la experiencia.
  def sell_experience!
    if self.experience_id.presence and self.experience.published?
      self.experience.sell!
    end
  end

  # Internal: Setea por defecto el valor de la columna :quantity, utilizando para
  #           ello el tipo de exclusividad seleccionada para el evento, modificando
  #           en caso de ser necesario el valor de la columan :swaps dejandolo
  #           en 0 (cero), en caso de exclusividades que reservan stock.
  #           Si la columna tiene un valor previo, este se mantiene.
  def set_quantity_and_swaps!
    if self.exclusivity_id == Exclusivity.total_id
      if self.experience_id.presence
        self.quantity = self.experience_swaps unless self.quantity.presence
      end
      self.swaps = nil
    elsif self.exclusivity_id == Exclusivity.by_industry_id
      if self.efi_id.presence
        self.quantity = experience.industry_swaps(self.efi) if not self.quantity.presence and not self.experience_id.nil?
      end
      self.swaps = nil
    else
      self.quantity = nil
    end
  end
end
