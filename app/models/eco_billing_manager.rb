class EcoBillingManager
  attr_accessor :eco, :start_at, :end_at
  def initialize(eco, opts={})
    self.eco = eco
    start_at, end_at = invoice_period
    self.start_at = opts[:start_at] || start_at
    self.end_at = opts[:end_at] || end_at
  end

  def invoice_period
    start_day = Settings.eco_billing_day
    now = Time.now
    current_month = now.month
    current_year = now.year
    start_at = Time.new(current_year, current_month, start_day).beginning_of_day
    end_at = (Time.new(current_year, (current_month + 1) % 12, start_day) - 1.day).end_of_day
    [start_at, end_at]
  end

  def totals
    income = charge = to_pay = 0
    experiences.each do |e|
      t = invoice_summary(e)
      income += t[:income]
      charge += t[:charge]
      to_pay += t[:to_pay]
    end
    {
      income: income,
      charge: charge,
      to_pay: to_pay
    }
  end

  def to_pay(experience)
    experience_income = invoice_summary(experience)[:income]
    experience_income - experience_income * experience.fee/100.0
  end

  def by_experience
    experiences.collect do |experience|
      invoice_summary(experience)
    end
  end
  
  def transactions_grouped_by_experience
    experience_ids = self.eco.experiences.where(state: 'on_sale').pluck(:id)
    Event.select("experience_id, experiences.name as experience_name, experiences.fee as experience_fee, experiences.amount as price, experiences.discounted_price as discounted_price, experiences.income_type as income_type, SUM(quantity) as total_q").
      where("experience_id IN (?)", experience_ids).
      where("events.created_at >= ?", invoice_start_at).
      where("events.created_at <= ?", invoice_end_at).
      joins(:experience).
      group("experience_id, experiences.name, experiences.fee, experiences.amount, experiences.discounted_price, experiences.income_type").
      order("experience_name")
  end

  def income_by_sales(experience)
    transactions = transactions_detail(experience)
    total_q = transactions.inject(0) { |result, t| result + t.quantity }
    income = total_q * experience.amount
    charge = income * experience.fee/100.0
    {
      experience: experience.name,
      total_q: total_q,
      price: experience.amount,
      income_type: experience.income_type,
      income: income,
      fee: experience.fee,
      charge: charge,
      to_pay: income - charge
    }
  end

  def income_by_purchases(experience)
    transactions = transactions_detail(experience)
    total_q = transactions.count
    income = total_q * experience.discounted_price
    charge = income * experience.fee/100.0
    {
      experience: experience.name,
      total_q: total_q,
      price: experience.discounted_price,
      income_type: experience.income_type,
      income: income,
      fee: experience.fee,
      charge: charge,
      to_pay: income - charge
    }
  end

  def transactions_detail(experience)
    case experience.income_type
    when "Ventas"
      experience.events.where("events.created_at >= ?", self.start_at).where("events.created_at <= ?", self.end_at)
    when "Canjes"
      experience.purchases.where("purchases.created_at >= ?", self.start_at).where("purchases.created_at <= ?", self.end_at)
    when "Validaciones"
      experience.purchases.where("purchases.updated_at >= ?", self.start_at).where("purchases.updated_at <= ?", self.end_at)
    end
  end

  def experiences
    self.eco.experiences.where("experiences.state IN (?)", [:on_sale, :closed]).
      includes(:events, :purchases).
      where("(events.created_at >= :start_at AND events.created_at <= :end_at) OR (purchases.created_at >= :start_at AND purchases.created_at <= :end_at) OR (purchases.updated_at >= :start_at AND purchases.updated_at <= :end_at)", start_at: self.start_at, end_at: self.end_at).
      order("experiences.name")
  end

  def invoices(opts={})
    eco.invoices.order("start_at desc").paginate(page: opts[:page], per_page: 12)
  end

  def store_invoice!
    invoice = eco.invoices.find_or_initialize_by_start_at_and_end_at(start_at: self.start_at, end_at: self.end_at)
    t = totals
    invoice.income = t[:income]
    invoice.charge = t[:charge]
    invoice.to_pay = t[:to_pay]
    invoice.state = :to_pay
    invoice.save!
  end

end
