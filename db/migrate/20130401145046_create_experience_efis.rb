class CreateExperienceEfis < ActiveRecord::Migration
  def change
    create_table :experience_efis do |t|
      t.references :experience
      t.references :efi

      t.timestamps
    end
    add_index :experience_efis, :experience_id
    add_index :experience_efis, :efi_id
  end
end
