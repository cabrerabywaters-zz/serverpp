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
end