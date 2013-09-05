class EcoBillingManager
  attr_accessor :eco
  
  def initialize(eco)
    self.eco = eco
  end
  
  def total_income
    transactions = transactions_grouped_by_experience
    income_by_experience = transactions.collect do |t|
      income_fx = "sales"
      case income_fx
      when "sales"
        income_by_sales(t)
      when "purchases"
        income_by_purchases(t)
      when "validations"
        income_by_validations(t)
      end
    end
    income_by_experience.inject(0) { |total, i| i + total }
  end
  
  def income_by_experience
    transactions = transactions_grouped_by_experience
    income_by_experience = transactions.collect do |t|
      fee = t["experience_fee"].to_i
      income_fx = t["income_type"]
      income = case income_fx
      when "Ventas"
        income_by_sales(t)
      when "Canjes"
        income_by_purchases(t)
      when "Validaciones"
        income_by_validations(t)
      end || 0
      charge = income * fee/100.0
      { experience: t["experience_name"], total_q: t["total_q"], price: t["price"], income_type: t["income_type"], income: income, fee: fee, charge: charge, to_pay: (income - charge) }
    end
  end
  
  def transactions_grouped_by_experience
    experience_ids = Experience.where(state: 'on_sale').pluck(:id)
    Event.select("experience_id, experiences.name as experience_name, experiences.fee as experience_fee, experiences.amount as price, experiences.discounted_price as discounted_price, experiences.income_type as income_type, SUM(quantity) as total_q").
      where("experience_id IN (?)", experience_ids).
      where("events.created_at >= ?", invoice_start_at).
      where("events.created_at <= ?", invoice_end_at).
      joins(:experience).
      group("experience_id, experiences.name, experiences.fee, experiences.amount, experiences.discounted_price, experiences.income_type").
      order("experience_name")
  end
  
  def invoice_start_at
    Time.now.beginning_of_month
  end
  
  def invoice_end_at
    Time.now.end_of_month
  end
  
  def income_by_sales(t)
    t["total_q"].to_i * t["price"].to_i
  end
  
  def income_by_validations(t)
    0
  end
  
  def income_by_purchases(t)
    0
  end
  
  def transactions_by_experience
    experience_ids = Experience.where(state: 'on_sale').pluck(:id)
    experiences = Event.includes(:experience).
      where("experience_id IN (?)", experience_ids).
      where("events.created_at >= ?", invoice_start_at).
      where("events.created_at <= ?", invoice_end_at).
      group_by { |e| e.experience }
    
    experiences_summary = income_by_experience
    experiences.collect do |experience, transactions|
      summary = experiences_summary.select {|e| e[:experience] == experience.name }.first
      { experience: experience, summary: summary, transactions: transactions }
    end
  end
  
end
