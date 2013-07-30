module Api
  class Cmr::PurchasesController < Api::BaseController
    include WashOut::SOAP

    soap_action "CreatePurchase",
                :args => { :rut => :string, :email => :string, :exchange_id => :integer, :reference_codes => [:string] } ,
                :return => :string
    def create_purchase

    end

    soap_action "ConfirmPurchase",
                :args => { :purchase_id => :integer },
                :return => :string
    def confirm_purchase

    end

    soap_action "RedeemPurchase",
                :args => { :purchase_id => :integer },
                :return => :string
    def redeem_purchase

    end
  end
end