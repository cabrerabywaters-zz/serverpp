class EfiBillingManager
  attr_accessor :efi

  def initialize(efi)
    @efi = efi
  end

  def to_pay_invoices
    efi.invoices.to_pay
  end

  def total_to_pay
    efi.invoices.to_pay.inject(0) {|a, i| i.total + a }
  end

  def paid_invoices
    efi.invoices.paid
  end

  def paid_invoices_by_month(opts={})
    efi.invoices.paid.select("date_trunc('month', created_at) AS month, date_trunc('year', created_at) AS year, SUM(total) AS total").group("month, year").order("month desc, year desc").paginate(page: opts[:page], per_page: 12)
  end

  def to_pay_events
    last_invoice_date = efi.invoices.order('created_at desc').limit(1).first.try(:billing_ended_at)
    total_events = efi.events.where(exclusivity_id: Exclusivity.total_id)
    industry_events = efi.events.where(exclusivity_id: Exclusivity.by_industry_id)
    without_events = efi.events.where(exclusivity_id: Exclusivity.without_id)
    purchases = Purchase.joins(exchange: { event: :experience }).where("event_id IN (?)", without_events.collect(&:id))
    if last_invoice_date.present?
      total_events = total_events.where("created_at >= ?", last_invoice_date)
      industry_events = industry_events.where("created_at >= ?", last_invoice_date)
      without_events = industry_events.where("created_at >= ?", last_invoice_date)
      purchases = purchases.where("created_at >= ?", last_invoice_date)
    end
    purchases_by_experience = purchases.group(:experience_id).count

    billing = (total_events + industry_events).collect do |event|
      {
        experience: event.experience.name,
        experience_id: event.experience.id,
        stock: event.quantity,
        price: event.experience.discounted_price,
        comision: 15,
        to_pay: event.quantity * event.experience.discounted_price * 0.15
      }
    end

    without_billing = efi.available_experiences.where("experiences.id IN (?)", purchases_by_experience.keys).collect do |experience|
      {
        experience: experience.name,
        experience_id: experience.id,
        stock: purchases_by_experience[experience.id.to_s],
        price: experience.discounted_price,
        comision: 15,
        to_pay: purchases_by_experience[experience.id.to_s] * experience.experience.discounted_price * 0.15
      }
    end

    billing + without_billing
  end
  
  def make_invoice(selected_experiences, end_at)
    last_invoice_date = efi.invoices.order('created_at desc').limit(1).first.try(:billing_ended_at)
    invoice = efi.efi_invoices.build(billing_started_at: start_at, billing_ended_at: end_at)
    invoice_items = to_pay_events.select {|i| selected_experiences.include?(i[:experience_id])}
    invoice_items.each do |invoice_item|
      invoice.efi_invoice_items.build(experience_id: invoice_item[:experience_id], comision: 15, price: invoice_item[:price], stock: invoice_item[:stock], total: invoice_item[:to_pay])
    end
    invoice.total = invoice_items.inject(0) {|a, i| i[:to_pay] + a}
    invoice.save
  end
    
end