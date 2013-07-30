# encoding: utf-8

# Public: Clase para manejar las Industrias a las que puede pertenecer una EFI.
#
# @private Date|NilClass set_percentage!() Callback para setea por defecto un valor
#                                          en la columna :percentage.
class Industry < ActiveRecord::Base
  attr_accessible :name,
                  :percentage

  has_many :industry_efis, dependent: :destroy
  # Las EFI's que pertenecen a esta Industry
  has_many :efis, through: :industry_efis

  # Valida la presencia y la unicidad de la columna :name
  validates :name, presence: true, uniqueness: true

  validates_presence_of :percentage

  # Valida la Industria en términos de porcentajes globales, es decir mantiene
  # las industias con un porcentaje globalmente de 100%.
  # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
  validate :global_percentage

  after_initialize  :set_percentage!
  before_validation :set_percentage!
  private
  # Internal: Callback para setea por defecto un valor en la columna :percentage,
  #           salvo en  casos que la columna ya tenga un valor
  #
  # Retorna un Float con el valor seteado en la columna,
  #         o NilClass en caso de que no se modifique la columna :percentage.
  def set_percentage!
    self.percentage = [100 - Industry.sum(:percentage), 0].max unless self.percentage.presence
  end

  # Internal: Callback que valida la Industria en términos de porcentajes globales,
  #           es decir mantiene las industrias con un porcentaje globalmente de 100%.
  #
  # Retorna nil.
  def global_percentage
    if self.new_record?
      available_percentage = [100 - Industry.sum(:percentage), 0].max
    else
      available_percentage = [100 - Industry.where('id != ?', self.id).sum(:percentage), 0].max
    end

    self.validates_numericality_of :percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: available_percentage
  end
end
