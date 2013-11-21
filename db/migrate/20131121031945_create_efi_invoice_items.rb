class CreateEfiInvoiceItems < ActiveRecord::Migration
  def change
    create_table :efi_invoice_items do |t|
      t.references :efi_invoice, null: false
      t.references :experience, null: false
      t.integer :stock
      t.integer :price
      t.float :comision
      t.float :total

      t.timestamps
    end
    add_index :efi_invoice_items, :efi_invoice_id
    add_index :efi_invoice_items, :experience_id
  end
end
