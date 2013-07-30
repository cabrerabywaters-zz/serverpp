class ChangePriceTypeToExperiences < ActiveRecord::Migration
  def up
    change_column :experiences, :amount,           :integer
    change_column :experiences, :discounted_price, :integer
  end

  def down
    change_column :experiences, :amount,           :float
    change_column :experiences, :discounted_price, :float
  end
end
