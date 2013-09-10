# encoding: utf-8

# Public: Variables de configuración globales.
#
module Settings
  extend self

  # Minimo porcentaje de canjes para eventos sin exclusividad
  def minimum_percentage_swap_without_exclusivity
    0.1
  end

  # Define la url de la aplicación, esto es utilizado para obtener la url del
  # catalogo de la EFI.
  # Mas información en: app/modesl/efi.rb
  def url
    if Rails.env.production?
      'http://54.225.244.183/empresa/'
    else
      'http://localhost:3000/empresa/'
    end
  end

  # Hora del dia (de 24hrs) en que se ejecuta el worker para cerrar eventos
  def close_events_at
    3
  end

  # Hora del dia (de 24hrs) en que se ejecuta el worker para cerrar experiencias
  def close_experiences_at
    3
  end

  # Hora del dia (de 24hrs) en que se ejecuta el worker para expirar experiencias
  def expire_experiences_at
    3
  end

  def admin_eco
    "Administrador ECO"
  end

  def operator_eco
    "Operador ECO"
  end

  def admin_efi
    "Administrador EFI"
  end

  def admin_puntospoint
    "Administrador"
  end

  def eco_billing_day
    (ENV['ECO_BILLING_DAY'] || 1).to_i
  end

  def eco_billing_invoice_hour
    (ENV['ECO_BILLING_INVOICE_HOUR'] || 4).to_i
  end
end