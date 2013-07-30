class CreateExperienceAdvertisings < ActiveRecord::Migration
  def change
    create_table :experience_advertisings do |t|
      t.references :experience
      t.references :advertising

      t.timestamps
    end
    add_index :experience_advertisings, :experience_id
    add_index :experience_advertisings, :advertising_id
  end
end
