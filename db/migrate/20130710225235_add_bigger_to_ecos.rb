class AddBiggerToEcos < ActiveRecord::Migration
  def change
    add_column :ecos, :bigger, :boolean
  end
end
