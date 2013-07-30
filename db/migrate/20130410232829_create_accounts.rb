class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :client
      t.references :efi
      t.integer :points

      t.timestamps
    end
    add_index :accounts, :client_id
    add_index :accounts, :efi_id
  end
end
