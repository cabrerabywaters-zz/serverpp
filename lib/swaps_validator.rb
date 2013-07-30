#encoding: utf-8

# Validador personalizado encargado de validar una compra.
# Este se encarga de validar que para crear la compra (Purchase) deben existir
# canjes disponibles para el evento que puso a disposición la EFI, para esto se
# consideran las formas de canje dispuestas por cada EFI al momento de crear el
# evento, además se toma en cuenta los eventos sin exclusividades, versus los
# eventos con exclusividad por indistria.
#
# Mas información en: lib/swaps_validator.rb
#
class SwapsValidator < ActiveModel::Validator
  # Función para validar
  def validate record
    if record.exchange_id.presence
      event    = record.exchange.event

      if record.new_record?
        purchases_count = event.purchases.count
      else
        purchases_count = event.purchases.count - 1
      end

      if event.exclusivity_id == Exclusivity.total_id or event.exclusivity_id == Exclusivity.by_industry_id
        record.errors[:base] << I18n.t('activerecord.errors.messages.not_available_purchases') unless purchases_count < event.quantity
      else
        experience = event.experience
        reserved_purchases = experience.events.exclusivity_by_industry.sum(&:quantity) + experience.events.total_exclusivity.sum(&:quantity)

        if record.new_record?
          nonexclusive_purchase = experience.events.without_exclusivity.map(&:purchases).flatten.count
        else
          nonexclusive_purchase = experience.events.without_exclusivity.map(&:purchases).flatten.count - 1
        end

        available_purchases = [[experience.swaps - reserved_purchases - nonexclusive_purchase, 0].max + purchases_count, event.swaps].min

        record.errors[:base] << I18n.t('activerecord.errors.messages.not_available_purchases') unless purchases_count < available_purchases
      end
    end
  end
end
