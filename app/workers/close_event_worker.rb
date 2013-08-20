# encoding: utf-8

# Public: Worker que se encarga de cerrar los eventos de experiencias que ya no
#         están disponibles para ser canjeados en la mini-pagina de la EFI.
#
# Mas información en: https://github.com/tobiassvn/sidetiq
#
class CloseEventWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  # Planificación del worker
  tiq do
    daily.hour_of_day(Settings.close_events_at)
  end

  # Callback que ejecutado
  def perform#(last_occurrence, current_occurrence)
    Event.are_taken_or_published.each do |event|
      event.close! if event.experience.ending_at < Date.current
    end
  end
end