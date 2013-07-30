class ChangeSummaryToTextIntoExperiences < ActiveRecord::Migration
  def up
    change_column :experiences, :summary, :text
  end

  def down
    change_column :experiences, :summary, :string
  end
end
