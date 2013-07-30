class AddCodesToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :codes, :text
  end
end
