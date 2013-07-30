class AddVaucheValidityDatesToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :validity_starting_at, :datetime
    add_column :experiences, :validity_ending_at,   :datetime
  end
end
