#encoding: utf-8

# Validador personalizado encargado de validar un evento.
# Este se encarga de las validaciones sobre los evento 'sin exclusividad'.
#
# Mas información en: lib/without_exclusivity_validator.rb
#
class WithoutExclusivityValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.exclusivity_id == Exclusivity.without_id
      record.validates_presence_of :swaps

      if record.experience.presence
        if record.experience.events.exclusivity_by_industry.any? and record.new_record?
          max_swaps = record.experience_swaps - record.experience.events.exclusivity_by_industry.sum(&:quantity)
        else
          max_swaps = record.experience_swaps
        end

        min_swaps = [record.experience.minimum_without_swaps, max_swaps].min

        if min_swaps > 0
          record.validates_numericality_of :swaps, greater_than_or_equal_to: min_swaps, less_than_or_equal_to: max_swaps, only_integer: true
        else
          record.validates_numericality_of :swaps, greater_than: 0, less_than_or_equal_to: max_swaps, only_integer: true
        end

        if record.new_record?
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.total_exclusivity.any?
        else
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.total_exclusivity.where('id != ?', record.id).any?
        end
      else
        record.validates_numericality_of :swaps, greater_than: 0, only_integer: true
      end
    end
  end
end