module Api
  class Cmr::EventsController < Api::BaseController
    include WashOut::SOAP

    soap_action :get_events,
                :return => [Api::Cmr::EventList]
    def get_events
      render soap: Api::Cmr::EventList.fetch(@efi)
    end

    soap_action :get_event,
                :args => { :event_id => :integer },
                :return => Api::Cmr::Event
    def get_event
      render soap: Api::Cmr::Event.fetch(@efi, params[:event_id])
    end

    soap_action :create_purchase,
                :args => { :rut => :string, :email => :string, :exchange_id => :integer, :reference_codes => [:string] } ,
                :return => Api::Cmr::Purchase
    def create_purchase
      render soap: Api::Cmr::Purchase.create(@efi, params)
    end

    soap_action :confirm_purchase,
                :args => { :purchase_id => :integer },
                :return => Api::Cmr::PurchaseDetails
    def confirm_purchase
      render soap: Api::Cmr::PurchaseDetails.confirm(@efi, params[:purchase_id])
    end

    soap_action :redeem_purchase,
                :args => { :purchase_id => :integer },
                :return => Api::Cmr::Purchase
    def redeem_purchase
      render soap: Api::Cmr::Purchase.redeem(@efi, params[:purchase_id])
    end
  end
end