# encoding: utf-8

# Public: Worker que se encarga de cerrar las experiencias que ya no están
#         disponibles para las EFI's
#
# Mas información en: https://github.com/tobiassvn/sidetiq
#
class CloseExperienceWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  # Planificación del worker
  tiq do
    daily.hour_of_day(Settings.close_experiences_at)
  end

  # Callback que ejecutado
  def perform#(last_occurrence, current_occurrence)
    Experience.published_or_active.each do |experience|
      experience.close! if experience.ending_at < Date.current
    end
  end
end