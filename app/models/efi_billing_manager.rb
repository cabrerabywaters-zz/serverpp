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

  def to_pay_events(opts={})
    billing_ended_at = opts[:billing_ended_at] || Time.now
    total_events = efi.events.
      joins("INNER JOIN experiences ON events.experience_id=experiences.id").
      joins("LEFT OUTER JOIN efi_invoice_items ON experiences.id=efi_invoice_items.experience_id").
      where(exclusivity_id: Exclusivity.total_id).
      where("efi_invoice_items.id IS NULL")
    industry_events = efi.events.joins(:experience).
      joins("LEFT OUTER JOIN efi_invoice_items ON experiences.id=efi_invoice_items.experience_id").
      where(exclusivity_id: Exclusivity.by_industry_id).
      where("efi_invoice_items.id IS NULL")

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

    # Para cada evento sin exclusividad con estado published o taken
    without_billing_events = efi.events.includes(:experience).with_states(:published, :taken).where(exclusivity_id: Exclusivity.without_id).collect do |event|
      # Tengo que buscar las compras hechas despues de la ultima fecha de facturación de la experiencia
      purchases = Purchase.joins(exchange: { event: :experience }).where("events.id =?", event.id)
      last_billing_date = EfiInvoiceItem.includes(:efi_invoice).where(experience_id: event.experience.id).first.try(:efi_invoice).try(:billing_ended_at)
      if last_billing_date
        purchases = purchases.where("purchases.created_at >= ?", last_billing_date).where("purchases.created_at < ?", billing_ended_at)
      end
      {
        experience: event.experience.name,
        experience_id: event.experience.id,
        stock: purchases.count,
        price: event.experience.discounted_price,
        comision: 15,
        to_pay: purchases.count * event.experience.discounted_price * 0.15
      }
    end
    without_billing_events = without_billing_events.select {|e| e[:stock] > 0}

    # Se agrupa por experiencia
    without_billing = []
    without_billing_events.group_by {|i| i[:experience_id]}.each do |experience_id, grouped_events|
      first = grouped_events.first
      without_billing << {
        experience: first[:experience],
        experience_id: first[:experience_id],
        stock: grouped_events.inject(0) {|a, e| a + e[:stock] },
        price: first[:price],
        comision: first[:comision],
        to_pay: grouped_events.inject(0) {|a, e| a + e[:to_pay] }
      }
    end

    billing + without_billing
  end

  def make_invoice(selected_experiences, end_at)
    start_at = efi.invoices.order('created_at desc').limit(1).first.try(:billing_ended_at) || efi.available_experiences.order('created_at desc').limit(1).first.created_at
    invoice = efi.invoices.build
    invoice.billing_started_at = start_at
    invoice.billing_ended_at = end_at
    invoice_items = to_pay_events(billing_ended_at: end_at).select {|i| selected_experiences.include?(i[:experience_id].to_s)}
    invoice_items.each do |invoice_item|
      invoice.efi_invoice_items.build(experience_id: invoice_item[:experience_id], comision: 15, price: invoice_item[:price], stock: invoice_item[:stock], total: invoice_item[:to_pay])
    end
    invoice.total = invoice_items.inject(0) {|a, i| i[:to_pay] + a}
    invoice.save
  end

end