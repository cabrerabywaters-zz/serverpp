class AddComparedToEfis < ActiveRecord::Migration
  def change
    add_column :efis, :compared, :boolean
  end
end
