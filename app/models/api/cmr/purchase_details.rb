# Modulo que encapsula la API
module Api
  # Clase para manejar las Compras como un tipo de dato valido para la API
  class Cmr::PurchaseDetails < WashOut::Type
    # Definicion de un nombre valido para la clase que pueda ser interpretado por la API
    type_name 'purchase'

    # List of attributes returned by this Class
    map purchase_id: :integer,
        exchange_id: :integer,
        rut: :string,
        email: :string,
        code: :string,
        reference_codes: [:string],
        # url: :string,
        status: :string,
        errors: [:string],
        voucher: :string

    # Método que permite confirmar una compra
    #
    # @parametros:
    # EFI      efi          -  Una instancia de una EFI
    # Integer  purchase_id  -  Id de la compra que se quiere confirmar
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
                voucher: Rails.application.routes.url_helpers.corporative_voucher_url(purchase, corporative_id: efi.search_name, token: purchase.token, format: :pdf),
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