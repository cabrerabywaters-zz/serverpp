#encoding: utf-8

# Validador personalizado encargado de validar un evento.
# Este se encarga de validar que para crear el evento sobre una experiencia,
# esta deber estar disponible para la efi en cuestion.
# Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-validators
#
class ExperienceAvailableValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.new_record? and record.efi.presence and record.experience.presence and not record.experience.available_efis.include?(record.efi)
      record.errors[:experience] << I18n.t('activerecord.errors.messages.has_no_available', Experience.model_name.human)
    end
  end
end