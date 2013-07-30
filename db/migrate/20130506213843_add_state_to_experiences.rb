class AddStateToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :state, :string
  end
end
