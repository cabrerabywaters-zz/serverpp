class Invoice < ActiveRecord::Base
  belongs_to :eco
  attr_accessible :charge, :end_at, :income, :start_at, :state, :to_pay
end
