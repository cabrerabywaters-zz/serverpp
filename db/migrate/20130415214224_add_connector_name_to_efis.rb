class AddConnectorNameToEfis < ActiveRecord::Migration
  def change
    add_column :efis, :connector_name, :string
  end
end
