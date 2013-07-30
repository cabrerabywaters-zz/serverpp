# encoding: utf-8

# Public: Clase para manejar las transacciones de puntos en un cuenta.
#
# @public Operation operation() Entrega la operación de la transacción.
#
# @private NilClass update_account_points_balance!() Callback para actualizar los
#                                                    puntos de la cuenta del usuario.
#
class Transaction < ActiveRecord::Base
  attr_accessible :operation_id,
                  :points,
                  :account_id,
                  :account

  belongs_to :account

  validates_presence_of :operation_id,
                        :points

  validates_presence_of :account_id, on: :update

  # Valida que el id de la operación debe ser uno de los definidos.
  validates :operation_id, :inclusion => { :in =>  Operation.ids}

  # Valida la transacción en términos de descontar puntos, vale decir,
  # que la cuenta tenga los puntos suficientes para ser descontados
  # Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
  validate :valid_account_points?

  # Internal: Entrega la operación de la transacción. Dado que el modelo que maneja
  #           las operaciones no es un modelo persistido, no es posible acceder
  #           a el con ActiveRecord, esta función es similar a tener el modelo
  #           persistido y usando un belongs_to :operation
  # Ejemplo
  #   a) Para un evento con operation_id: 1
  #     full_name
  #     # => #<Operation:0x007f9b41242a28 @id="1", @name="Ajuste de Punt", @mechanism="=">
  #
  # Retorna una instancia de Operation.
  def operation
    Operation.find(operation_id)
  end

  before_create :update_account_points_balance!
  private
  # Internal: Callback para actualizar los puntos de la cuenta del usuario.
  def update_account_points_balance!
    if operation.mechanism == '+'
      account.points = (account.points + self.points)
    elsif operation.mechanism == '-'
      account.points = (account.points - self.points)
    else
      account.points = self.points
    end
    account.save unless account.new_record?
  end

  # Internal: Callback para validar la transacción en términos de descontar puntos,
  #            vale decir, que la cuenta tenga los puntos suficientes para ser
  #            descontados. http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-methods
  #
  # Retorna nil.
  def valid_account_points?
    if points.presence and operation_id.presence and account.presence
      errors.add(:points, I18n.t('activerecord.errors.messages.insufficient_points')) if account.points < points  and operation.mechanism == '-'
    end
  end
end
