class EcoBillingManager
  attr_accessor :eco, :start_at, :end_at
  def initialize(eco, opts={})
    self.eco = eco
    self.start_at = opts[:start_at] || Time.now.beginning_of_month
    self.end_at = opts[:end_at] || Time.now.end_of_month
  end

  def total_to_pay
    experiences.inject(0) do |result, e|
      result + to_pay(e)
    end
  end

  def to_pay(experience)
    experience_income = income_summary(experience)[:income]
    experience_income - experience_income * experience.fee/100.0
  end

  def by_experience
    experiences.collect do |experience|
      income_summary(experience)
    end
  end

  def income_summary(experience)
    case experience.income_type
    when "Ventas"
      income_by_sales(experience)
    when "Canjes"
      income_by_purchases(experience)
    when "Validaciones"
      income_by_purchases(experience)
    end
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

  def invoices
    eco.invoices.order(:start_at)
  end

end
