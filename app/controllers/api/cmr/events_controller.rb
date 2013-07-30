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
                :return => :string
    def create_purchase
      
    end

    soap_action :confirm_purchase,
                :args => { :purchase_id => :integer },
                :return => :string
    def confirm_purchase
      
    end

    soap_action :redeem_purchase,
                :args => { :purchase_id => :integer },
                :return => :string
    def redeem_purchase
      
    end
  end
end