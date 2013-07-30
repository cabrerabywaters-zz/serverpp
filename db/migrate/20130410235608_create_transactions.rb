class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :operation_id
      t.integer :points
      t.references :account

      t.timestamps
    end
    add_index :transactions, :account_id
  end
end
