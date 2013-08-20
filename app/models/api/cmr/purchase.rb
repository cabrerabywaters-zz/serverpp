module Api
  class Cmr::Purchase < WashOut::Type
    type_name 'purchase'

    map purchase_id: :integer,
        exchange_id: :integer,
        rut: :string,
        email: :string,
        reference_codes: [:string],
        errors: [:string],
        url: :string
    def self.create efi, purchase_attributes
      if efi.exchanges.exists?(purchase_attributes[:exchange_id])
        purchase = Purchase.new(purchase_attributes)
        purchase.required_password = false

        if purchase.save
          {
            value: {
              purchase_id: purchase.id,
              exchange_id: purchase.exchange_id,
              rut: purchase.rut,
              email: purchase.email,
              reference_codes: purchase.reference_codes,
              url: Rails.application.routes.url_helpers.corporative_purchase_url(purchase, corporative_id: efi.search_name)
            }
          }
        else
          {
            value: {
              exchange_id: purchase.exchange_id,
              rut: purchase.rut,
              email: purchase.email,
              reference_codes: purchase.reference_codes,
              errors: purchase.errors.full_messages
            }
          }
        end
      else
        {
          value: {
            exchange_id: purchase_attributes[:exchange_id],
            rut: purchase_attributes[:rut],
            email: purchase_attributes[:email],
            reference_codes: purchase_attributes[:reference_codes],
            errors: [I18n.t('errors.messages.unknown_model', model: Exchange.model_name.human)]
          }
        }
      end
    end

    map purchase_id: :integer,
        errors: [:string],
        status: :string
    def self.redeem efi, purchase_id
      if efi.purchases.exists?(purchase_id)
        purchase = Purchase.find(purchase_id)

        if purchase.redeem!
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