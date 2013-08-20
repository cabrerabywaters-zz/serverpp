#encoding: utf-8

# Validador personalizado encargado de validar un evento.
# Este se encarga de validar que para crear el evento sobre una experiencia,
# esta deber estar disponible para la efi en cuestion.
# Mas información en: http://guides.rubyonrails.org/active_record_validations_callbacks.html#custom-validators
#
class ExperienceNameValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.name.presence
      Experience.are_published.started.each do |experience|
        if experience != record and experience.name == record.name and experience.swaps != experience.purchases.count
          record.errors[:name] << I18n.t('errors.messages.taken')
        end
      end
    end
  end
end