# encoding: utf-8

# Public: Compras de los usuarios finales.
#
# @private String make_run_format!() Quita cualquier tipo de formato del rut
#                                    para mantener los datos consistentes.
#
# @private String set_internal_code!() Setea por defecto un código interno.
#
# @private Array set_reference_codes!() Setea por defecto los códigos de referencia.
#
# @private String generate_code() Genera un código de interno único y valido.
#
# @private String get_reference_code() Obtiene uno de los códigos subidos por la
#                                      ECO que no se ha usado aún.
#
# Mas información en: https://github.com/ryanb/cancan
#
class Purchase < ActiveRecord::Base
  # identifier_name:  Nombre del valor extra requerido para la integración.
  #                   EJ: número de teléfono, correo electrónico, etc.
  # identifier_value: Valor extra requerido para la integración.
  # points:           Puntos que se van a descontar.
  # Mas información en: http://www.rubyist.net/~slagell/ruby/accessors.html
  attr_accessor   :password

  attr_accessible :rut,
                  :email,
                  :password,
                  :exchange_id

  belongs_to :exchange

  # Serializa la columna reference_codes y almacena los códigos de refencia utilizados
  # por la ECO en formato YAML, pero para ser accedido se puede usar un Array
  serialize :reference_codes, Array

  validates_presence_of :exchange_id,
                        :email

  validates_presence_of :password, on: :create

  # Valida la presencia y la unicidad de la columna :code
  validates :code, presence: true, uniqueness: true

  # Valida la presencia y la unicidad de la columna :rut
  validates  :rut, presence: true, run: true

  # Búsqueda predefinida que permite filtrar/buscar las compras que estén validadas por la ECO.
  scope :are_validated, where(state: 'validated')

  # Definición de una maquina de estados para la compra, para lo cual se usa la
  # columna :state
  # Mas información en: https://github.com/pluginaweek/state_machine
  state_machine initial: :sold do
    event :validate! do
      transition sold: :validated
    end

    state :sold do
    end

    state :validated do
    end
  end

  # Internal: Permite obtener el estado en que se encuentra la compra, en un
  #           formato más legible por el usuario final, para esto usa el archivo
  #           de traducciones I18n (http://guides.rubyonrails.org/i18n.html).
  #
  # Retorna un String con contiene el nombre del estado ya traducido.
  def translate_state
    translate = I18n.t('state_machine.purchase.' + state)
    return translate unless translate.include?('translation missing:')

    return state
  end

  # Validador personalizado encargado de validar una compra, este se encarga de
  # validar que para crear la compra (Purchase) deben existir canjes disponibles
  # para el evento que puso a disposición la EFI, para esto se consideran las
  # formas de canje dispuestas por cada EFI al momento de crear el evento, además
  # se toma en cuenta los eventos sin exclusividades, versus los eventos con
  # exclusividad por indistria.
  # Mas información en: lib/swaps_validator.rb
  validates_with SwapsValidator

  # Valida que los código que sube la ECO no sean utilizado en mas de una compra.
  # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
  validate :valid_reference_codes

  after_initialize  :set_internal_code!
  before_validation :set_reference_codes!

  before_save :make_run_format!

  private
  # Internal: Quita cualquier tipo de formato del rut para guardar los rut de
  #           forma consistente en la base de datos.
  #
  # Ejemplo
  #   1) Para una cuenta con rut 12.345.678-5
  #     make_run_format!
  #     # => '123456785'
  #
  # Retorna un String con el rut sin formato.
  def make_run_format!
    self.rut = Run.remove_format(self.rut)
  end

  # Internal: Setea por defecto un código interno. Salvo en caso que la columna
  #           ya tenga un valor previo.
  #
  # Retorna un String con el valor seteado en la columna :code.
  def set_internal_code!
    self.code ||= generate_code
  end

  # Internal: Setea por defecto los códigos de referencia. Salvo en caso que la
  #           columna ya tenga un valor previo.
  #
  # Retorna un Array con los :reference_codes.
  def set_reference_codes!
    return self.reference_codes if self.reference_codes.any?

    if self.exchange_id.presence
      experience = self.exchange.event.experience

      if experience.codes_by_purchase.presence
        experience.codes_by_purchase.times.each do |i|
          self.reference_codes << get_reference_code
        end
      else
        self.reference_codes << get_reference_code
      end
    end

    return self.reference_codes
  end

  # Internal: Genera un código de interno único y valido.
  #
  # Retorna un String con el nuevo código generado.
  def generate_code
    while true
      if not Purchase.find_by_code generated_code = "#{self.exchange_id}#{Time.now.to_i}"
        return generated_code
      end
    end
  end

  # Internal: Obtiene uno de los códigos subidos por la ECO que no se ha usado aún.
  #           Si la ECO no subió ningún código, este se genera internamente.
  #
  # Retorna un String con el nuevo código generado.
  def get_reference_code
    if self.exchange_id.presence
      experience = self.exchange.event.experience
      if experience.codes.any?
        experience.codes.each do |experience_code|
          return experience_code unless experience.purchases.map(&:reference_codes).flatten.include?(experience_code) or self.reference_codes.include?(experience_code)
        end
      end
    end

    return "#{self.exchange_id}#{Time.now.to_i}"
  end

  # Internal: Valida que los código que sube la ECO no sea utilizado en mas de
  #           una compra.
  #
  # Retorna nil.
  def valid_reference_codes
    if self.exchange_id.presence
      experience = self.exchange.event.experience
      if experience.codes.any?
        self.reference_codes.each do |rc|
          self.errors[:reference_codes] << I18n.t('errors.messages.inclusion') unless experience.codes.include?(rc)
        end

        purchases  = experience.purchases - [self]
        self.reference_codes.each do |rc|
          self.errors[:reference_codes] << I18n.t('errors.messages.exclusion') if purchases.map(&:reference_codes).flatten.include?(rc)
        end
      end
    end
  end
end
