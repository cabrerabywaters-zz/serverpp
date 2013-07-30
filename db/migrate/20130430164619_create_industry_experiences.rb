class CreateIndustryExperiences < ActiveRecord::Migration
  def change
    create_table :industry_experiences do |t|
      t.references :industry
      t.references :experience
      t.float :percentage

      t.timestamps
    end
    add_index :industry_experiences, :industry_id
    add_index :industry_experiences, :experience_id
  end
end
