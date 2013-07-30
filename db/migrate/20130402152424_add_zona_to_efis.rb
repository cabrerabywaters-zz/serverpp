class AddZonaToEfis < ActiveRecord::Migration
  def change
    add_column :efis, :zona, :string
  end
end
