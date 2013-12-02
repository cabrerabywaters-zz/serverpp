class CreateEfiInvoices < ActiveRecord::Migration
  def change
    create_table :efi_invoices do |t|
      t.references :efi, null: false
      t.float :total, null: false
      t.string :state
      t.datetime :billing_started_at, null: false
      t.datetime :billing_ended_at, null: false
      t.datetime :paid_at

      t.timestamps
    end
    add_index :efi_invoices, :efi_id
  end
end
