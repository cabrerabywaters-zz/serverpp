class ChangeDatetimeToDateOnExperiences < ActiveRecord::Migration
  def up
    change_column :experiences, :starting_at, :date
    change_column :experiences, :ending_at,   :date

    change_column :experiences, :validity_starting_at, :date
    change_column :experiences, :validity_ending_at,   :date
  end

  def down
    change_column :experiences, :starting_at, :datetime
    change_column :experiences, :ending_at,   :datetime

    change_column :experiences, :validity_starting_at, :datetime
    change_column :experiences, :validity_ending_at,   :datetime
  end
end
