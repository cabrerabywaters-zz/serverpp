class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :eco
      t.date :start_at
      t.date :end_at
      t.float :income
      t.float :charge
      t.float :to_pay
      t.string :state

      t.timestamps
    end
    add_index :invoices, :eco_id
  end
end
