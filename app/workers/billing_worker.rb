# encoding: utf-8

# Public: Calculate and store the past month invoice
#
class BillingWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  tiq do
    # FIXME: Edge case ECO_BILLING_DAY >= 28
    monthly.day_of_month(Settings.eco_billing_day + 1).hour_of_day(Settings.eco_billing_invoice_hour)
  end

  def perform#(last_occurrence, current_occurrence)
    now = Time.now
    start_at = Time.new(now.year, now.prev_month.month, Settings.eco_billing_day).beginning_of_day
    end_at = Time.new(now.year, now.month, Settings.eco_billing_day).end_of_day
    Eco.all.each do |eco|
      billing = EcoBillingManager.new(eco, start_at: start_at, end_at: end_at)
      billing.store_invoice!
    end
  end
end