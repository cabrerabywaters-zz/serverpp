class AddFeeToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :fee, :float
  end
end
