class AddAttributesToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :rut, :string
    add_column :accounts, :name, :string
  end
end
