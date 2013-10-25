# encoding: utf-8

# Modulo que encapsula la API
module Api
  # Public: Controlador con las acciones de la API.
  class Cmr::EventsController < Api::BaseController
    include WashOut::SOAP

    # Endpoint para obtener una lista con los Eventos disponibles
    soap_action :get_events,
                :return => [Api::Cmr::EventList]
    def get_events
      render soap: Api::Cmr::EventList.fetch(@efi)
    end

    # Endpoint para obtener el detalle de un Evento, para ello se require que se envie como parametro el ID del Evento
    # a consultar, para obtener el ID se debe consultar :get_events
    #
    # @parametros:
    # Integer  event_id  -  Un id de un Evento
    soap_action :get_event,
                :args => { :event_id => :integer },
                :return => Api::Cmr::Event
    def get_event
      render soap: Api::Cmr::Event.fetch(@efi, params[:event_id])
    end

    # Endpoint reservar stock para una compra, para ello es necesario que se envien tanto los datos del cliente que a
    # iniciado el proceso de compra y las preferencias que el usuario seleccione, adicionalmente pueden enviar los
    # codigos internos, es importante recordar que el :exchange_id se entrega al momento de consultar :get_event.
    #
    # @parametros:
    # String   rut              -  Rol Único Nacional (RUN) del cliente
    # String   email            -  Correo Electrónico del cliente
    # Integer  exchange_id      -  Id de la Forma de canje elegida (Cash & Points)
    # Array    reference_codes  -  Un Arreglo con los codigos de referencia ó codigos internos que pueda manejar la
    #                              contraparte de la API
    soap_action :create_purchase,
                :args => { :rut => :string, :email => :string, :exchange_id => :integer, :reference_codes => [:string] } ,
                :return => Api::Cmr::Purchase
    def create_purchase
      render soap: Api::Cmr::Purchase.create(@efi, params)
    end

    # Endpoint que permite confirmar una compra, para ello es necesario que se envie el ID de la compra a confirmar,
    # es importante recordar que el ID de la compra se entrega al momento de consultar :create_purchase.
    #
    # @parametros:
    # Integer   purchase_id   -  Id de la compra a confirmar
    soap_action :confirm_purchase,
                :args => { :purchase_id => :integer },
                :return => Api::Cmr::PurchaseDetails
    def confirm_purchase
      render soap: Api::Cmr::PurchaseDetails.confirm(@efi, params[:purchase_id])
    end

    # Endpoint que permite redimir una compra, para ello es necesario que se envie el ID de la compra a redimir,
    # es importante recordar que el ID de la compra se entrega al momento de consultar :create_purchase.
    #
    # @parametros:
    # Integer   purchase_id   -  Id de la compra a confirmar
    soap_action :redeem_purchase,
                :args => { :purchase_id => :integer },
                :return => Api::Cmr::Purchase
    def redeem_purchase
      render soap: Api::Cmr::Purchase.redeem(@efi, params[:purchase_id])
    end
  end
end