class ExperienceCode < ActiveRecord::Base
  belongs_to :purchase
  attr_accessible :code, :sold_at, :validated_at

  validates :purchase_id, :code, presence: true
  validates :code, uniqueness: true

  after_initialize do
    self.code ||= SecureRandom.hex(3)
  end
end
