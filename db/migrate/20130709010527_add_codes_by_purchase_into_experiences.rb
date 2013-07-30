class AddCodesByPurchaseIntoExperiences < ActiveRecord::Migration
  def up
    add_column :experiences, :codes_by_purchase, :integer
  end

  def down
    remove_column :experiences, :codes_by_purchase
  end
end
