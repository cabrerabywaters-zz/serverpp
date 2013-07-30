class RemoveHourFromExperiences < ActiveRecord::Migration
  def up
    remove_column :experiences, :hour
  end

  def down
    add_column :experiences, :hour, :string
  end
end
