class AddSalesToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :total_exclusivity_sales,       :boolean
    add_column :experiences, :by_industry_exclusivity_sales, :boolean
    add_column :experiences, :without_exclusivity_sales,     :boolean
  end
end
