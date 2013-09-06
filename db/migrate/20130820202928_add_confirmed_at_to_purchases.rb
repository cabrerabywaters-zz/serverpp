class AddConfirmedAtToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :confirmed_at, :datetime
  end
end
