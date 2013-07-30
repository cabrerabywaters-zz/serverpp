class AddReferenceCodeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :reference_code, :string
  end
end
