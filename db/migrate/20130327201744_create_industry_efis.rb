class CreateIndustryEfis < ActiveRecord::Migration
  def change
    create_table :industry_efis do |t|
      t.references :industry
      t.references :efi

      t.timestamps
    end
    add_index :industry_efis, :industry_id
    add_index :industry_efis, :efi_id
  end
end
