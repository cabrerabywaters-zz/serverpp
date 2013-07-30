class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :quantity
      t.integer :swaps
      t.integer :exclusivity_id
      t.references :efi
      t.references :experience

      t.timestamps
    end
    add_index :events, :efi_id
    add_index :events, :experience_id
    add_index :events, :exclusivity_id
  end
end
