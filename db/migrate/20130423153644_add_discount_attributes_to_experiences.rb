class AddDiscountAttributesToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :discounted_price,    :float
  end
end
