module Api
  class Cmr::Purchase < WashOut::Type
    type_name 'purchase'

    # map purchase_id: :integer,
    #     exchange_id: :integer,
    #     rut: :string,
    #     email: :string,
    #     reference_codes: [:string],
    #     errors: [:string],
    #     url: :string

    map purchase_id: :integer,
        errors: [:string],
        status: :string

    def self.create efi, purchase_attributes
      if efi.exchanges.exists?(purchase_attributes[:exchange_id])
        # Si no envian codigos de referencia no tomo en cuenta el valor enviado
        purchase_attributes.delete(:reference_codes) unless purchase_attributes[:reference_codes].empty?

        # Elimino el formato del Rut
        purchase_attributes[:rut] = Run.remove_format(purchase_attributes[:rut])

        purchase = Purchase.new(purchase_attributes)
        purchase.required_password = false

        if purchase.save
          {
            value: {
              purchase_id: purchase.id,
              status: 'ok'
            }
          }
        else
          {
            value: {
              status: 'error',
              errors: purchase.errors.full_messages
            }
          }
        end
      else
        {
          value: {
            status: 'error',
            errors: [I18n.t('errors.messages.unknown_model', model: Exchange.model_name.human)]
          }
        }
      end
    end

    def self.redeem efi, purchase_id
      if efi.purchases.exists?(purchase_id)
        purchase = Purchase.find(purchase_id)

        if purchase.validated?
          {
            value: {
              status: 'error',
              errors: [I18n.t('errors.messages.already_redeemed')]
            }
          }
        elsif purchase.redeem!
          {
            value: {
              purchase_id: purchase.id,
              status: 'ok'
            }
          }
        else
          {
            value: {
              exchange_id: purchase.exchange_id,
              status: 'error',
              errors: purchase.errors.full_messages
            }
          }
        end
      else
        {
          value: {
            purchase_id: purchase_id,
            status: 'error',
            errors: [I18n.t('errors.messages.unknown_model', model: Purchase.model_name.human)]
          }
        }
      end
    end
  end
end