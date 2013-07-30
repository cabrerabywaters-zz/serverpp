# encoding: utf-8

# Public: Cuenta de puntos de los usuarios de una EFI en cuestión.
#
# @private String make_run_format!() Quita cualquier tipo de formato del rut
#                               para mantener los datos consistentes.
#
# @private (Integer|NilClass) set_points!() Setea por defecto los puntos de la
#                                           cuenta en 0 (cero).
#
# Mas información en: https://github.com/ryanb/cancan
#
class Account < ActiveRecord::Base
  attr_accessible :points,
                  :name,
                  :rut,
                  :efi_id,
                  :transactions_attributes,
                  :password

  belongs_to :efi
  has_many   :transactions, dependent: :destroy

  # Acepta atributos nesteados para transactions,
  # rechazando individualmente cada transacción si no se lea asignan puntos.
  accepts_nested_attributes_for :transactions,
                                reject_if: lambda {|t| t[:points].blank? }

  validates_presence_of :points,
                        :name,
                        :efi_id,
                        :password

  validates_numericality_of :points,
                            greater_than_or_equal_to: 0,
                            only_integer: true

  validates_uniqueness_of :rut,
                          scope: :efi_id

  # Valida la presencia de la columna :rut,
  # además valida el rut según el validador RunValidator
  # Mas información en: http://rubygems.org/gems/run_cl
  validates  :rut, presence: true, run: true

  before_save :make_run_format!
  after_initialize :set_points!

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

  # Internal: Setea por defecto los puntos de la cuenta en 0 (cero), modificando
  #           la columan :points.
  #           Si la columna tiene un valor previo, este se mantiene.
  #
  # Ejemplo
  #   a) Para una cuenta sin puntos
  #     set_points!
  #     # => '0'
  #
  #
  #   b) Para una cuenta con 100 puntos
  #     set_points!
  #       # => nil
  #
  # Retorna un Integer con el valor seteado en la columna (0),
  #         o NilClass en caso de que no se modifique la columna :points.
  def set_points!
    self.points = 0 unless self.points.presence
  end
end
