class AddDaysToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :total_exclusivity_days,       :integer
    add_column :experiences, :by_industry_exclusivity_days, :integer
    add_column :experiences, :without_exclusivity_days,     :integer
  end
end
