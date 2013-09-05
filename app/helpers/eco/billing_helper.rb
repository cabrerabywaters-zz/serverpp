# coding: utf-8

module Eco::BillingHelper
  def get_transaction_headers(experience)
    case experience[:income_type]
    when "sales"
      ["Fecha Venta", "Stock Vendido"]
    when "purchases"
      ["Fecha Canje", "Código Validación"]
    when "validations"
      ["Fecha Validación", "Código Seguridad"]
    else
      ["Fecha Validación", "Código Seguridad"]
    end
  end
end
