class AddCodeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :code, :string
  end
end
