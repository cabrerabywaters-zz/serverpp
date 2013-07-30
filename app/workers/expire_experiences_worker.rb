# encoding: utf-8

# Public: Worker que se encarga de expirar las experiencias que ya finalizo el
#         periodo de validación de vouchers
#
# Mas información en: https://github.com/tobiassvn/sidetiq
#
class ExpireExperiencesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  # Planificación del worker
  tiq do
    daily.hour_of_day(Settings.expire_experiences_at)
  end

  # Callback que ejecutado
  def perform(last_occurrence, current_occurrence)
    Experience.are_closed.each do |experience|
      experience.expire! if experience.validity_ending_at < Date.current
    end
  end
end