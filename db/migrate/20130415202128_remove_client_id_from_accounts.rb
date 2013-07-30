class RemoveClientIdFromAccounts < ActiveRecord::Migration
  def up
    remove_index  :accounts, :client_id
    remove_column :accounts, :client_id
  end

  def down
    add_column :accounts, :client_id, :integer
    add_index  :accounts, :client_id
  end
end
