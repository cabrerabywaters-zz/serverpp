#encoding: utf-8

# Validador personalizado encargado de validar un evento.
# Este se encarga de las validaciones sobre el evento en caso de se 'exclusivo por industria'.
#
# Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-validators
#
class IndustryExclusivityValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.exclusivity_id == Exclusivity.by_industry_id
      record.validates_presence_of :quantity
      if record.experience.presence
        if record.efi_id.presence
          record.validates_numericality_of :quantity, greater_than: 0, equal_to: record.experience.industry_swaps(record.efi), only_integer: true
        else
          record.validates_numericality_of :quantity, greater_than: 0, only_integer: true
        end

        if record.new_record?
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.total_exclusivity.any?

        else
          record.errors[:base] << I18n.t('activerecord.errors.messages.total_exclusivity_taken') if record.experience.events.total_exclusivity.where('id != ?', record.id).any?
        end

        record.errors[:base] << I18n.t('activerecord.errors.messages.industry_exclusivity_taken') unless available_exclusivity_by_industry?(record)
      else
        record.validates_numericality_of :quantity, greater_than: 0, only_integer: true
      end
    end
  end

  private
  # Internal: Indica si una experiencia para una efi esta disponible con
  #           'exclusividad por industria'. Para esto verifica las EFI que están
  #           participando y las industrias de las mismas, versus las industrias
  #           de la EFI en cuestión.
  #
  # Retorna Boolean.
  def available_exclusivity_by_industry? record
    return false unless record.experience.presence
    return false unless record.efi.presence

    efi        = record.efi
    experience = record.experience

    if record.new_record?
      return false if experience.events.total_exclusivity.any?
    else
      return false if experience.events.total_exclusivity.where('id != ?', record.id).any?
    end

    return true if experience.events.exclusivity_by_industry.empty?

    if record.new_record?
      return false if (experience.events.exclusivity_by_industry.map{|i| i.efi.industries}.flatten & efi.industries).any?
    else
      return false if (experience.events.exclusivity_by_industry.where('id != ?', record.id).map{|i| i.efi.industries}.flatten & efi.industries).any?
    end

    true
  end
end