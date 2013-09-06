# encoding: utf-8

# Public: Worker que se encarga de revisa si los eventos asociados a una experiencia tienen stock disponible o no.
#         Si ya no tiene stock guarda la fecha de cuando se agoto.
#         Si aun tiene o vuelve a tener stock disponible eliminando la fecha de cuando se agoto.
#
# Mas información en: https://github.com/tobiassvn/sidetiq
#
class CheckEventStockWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  # Callback que sera ejecutado
  def perform experience_id
    experience = Experience.find(experience_id)

    experience.events.are_published.started.each do |event|
      event.delay.check_stock!
    end
  end
end