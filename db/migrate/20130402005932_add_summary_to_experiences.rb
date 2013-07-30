class AddSummaryToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :summary, :string
  end
end
