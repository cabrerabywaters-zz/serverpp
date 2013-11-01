# coding: utf-8

module Eco::BillingHelper
  def get_transaction_headers(experience)
    case experience[:income_type]
    when "Ventas"
      ["Fecha Venta", "Stock Vendido"]
    when "Canjes"
      ["Fecha Canje", "Código Validación"]
    when "Validaciones"
      ["Fecha Validación", "Código Seguridad"]
    end
  end
end
