class AddSearchNameToEfis < ActiveRecord::Migration
  def change
    add_column :efis, :search_name, :string
    add_index  :efis, :search_name
  end
end
