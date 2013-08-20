class RemoveWithoutExclusivityDaysFromExperiences < ActiveRecord::Migration
  def up
    remove_column :experiences, :without_exclusivity_days
  end

  def down
    add_column :experiences, :without_exclusivity_days, :integer
  end
end
