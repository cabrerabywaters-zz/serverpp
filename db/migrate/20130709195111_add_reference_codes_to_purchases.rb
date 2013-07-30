class AddReferenceCodesToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :reference_codes, :text
  end
end
