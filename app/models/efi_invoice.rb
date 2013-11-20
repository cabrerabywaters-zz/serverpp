class EfiInvoice < ActiveRecord::Base
  belongs_to :efi
  validates :billing_started_at, :billing_ended_at, :total, presence: true

  scope :to_pay, -> { where(state: :billed) }
  scope :paid, -> { where(state: :paid) }

  state_machine initial: :billed do
    event :paid! do
      transition billed: :paid
    end
  end
end
