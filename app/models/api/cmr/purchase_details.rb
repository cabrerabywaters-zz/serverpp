module Api
  class Cmr::PurchaseDetails < WashOut::Type
    type_name 'purchase'

    map purchase_id: :integer,
        exchange_id: :integer,
        rut: :string,
        email: :string,
        code: :string,
        reference_codes: [:string],
        # url: :string,
        status: :string,
        errors: [:string]
    def self.confirm efi, purchase_id
      if efi.purchases.exists?(purchase_id)
        purchase = Purchase.find(purchase_id)

        if purchase.confirmed_at.nil?
          purchase.confirmed_at = DateTime.now

          if purchase.save
            {
              value: {
                purchase_id: purchase.id,
                exchange_id: purchase.exchange_id,
                rut: Run.format(purchase.rut),
                email: purchase.email,
                code: purchase.code,
                reference_codes: purchase.reference_codes,
                # url: Rails.application.routes.url_helpers.corporative_purchase_url(purchase, corporative_id: efi.search_name),
                status: 'ok'
              }
            }
          else
            {
              value: {
                purchase_id: purchase_id,
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
              errors: [I18n.t('errors.messages.already_confirmed_at', model: Purchase.model_name.human, at: I18n.l(purchase.confirmed_at.localtime, format: :short))]
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