class BillingExperience
  attr_accessor :experience

  def initialize(experience)
    self.experience = experience
  end

  def calculate
    case experience.income_fx
    when :sold
      calculate_sold
    when :purchases
      calculate_purchases
    when :validations
      calculate_validations
    end
  end

  def total_income
    transactions = get_events(experience.billing.start_at, experience.billing.end_at)
    incomes = transactions.collect do |tx|
      sold_fx(tx)
    end

    incomes.inject(0) { |t, i| i + t }
  end

  def get_events(start_at, end_at)
    experience.events.where("create_at >= ?", start_at).where("created_at <= ?", end_at)
  end
end

class BillingSold
  def total_income
    transactions = get_transactions.group_by(:experience_id)
    incomes = transactions.collect do |tx|
      sold_fx(tx)
    end
    incomes.inject(0) { |t, i| i + t }
  end

  def transactions_by_experience
    Event.select("experience_id, SUM(quantity)").where("created_at >= ?", invoice_start_at).where("create_at <= ?", invoice_end_at).group(:experience_id)
  end

  def total_to_pay
    total_income * self.experience.fee
  end
end

