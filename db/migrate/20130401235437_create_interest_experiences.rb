class CreateInterestExperiences < ActiveRecord::Migration
  def change
    create_table :interest_experiences do |t|
      t.references :interest
      t.references :experience

      t.timestamps
    end
    add_index :interest_experiences, :interest_id
    add_index :interest_experiences, :experience_id
  end
end
