#encoding: utf-8

# Validador personalizado encargado de validar un evento.
# Este se encarga de las validaciones sobre los evento en con 'exclusividad total'.
#
# Mas información en: lib/total_exclusivity_validator.rb
#
class TotalExclusivityValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.exclusivity_id == Exclusivity.total_id
      record.validates_presence_of     :quantity
      if record.experience.presence
        record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_not_enabled') unless record.experience.total_exclusivity_enabled?

        record.validates_numericality_of :quantity, greater_than: 0, equal_to: record.experience_swaps, only_integer: true

        if record.new_record?
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.any?
        else
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.where('id != ?', record.id).any?
        end
      else
        record.validates_numericality_of :quantity, greater_than: 0, only_integer: true
      end
    end
  end
end