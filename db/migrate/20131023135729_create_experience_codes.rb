class CreateExperienceCodes < ActiveRecord::Migration
  def change
    create_table :experience_codes do |t|
      t.string :type
      t.string :code, null: false, unique: true
      t.references :purchase
      t.datetime :sold_at
      t.datetime :validated_at

      t.timestamps
    end
    add_index :experience_codes, :purchase_id
  end
end
