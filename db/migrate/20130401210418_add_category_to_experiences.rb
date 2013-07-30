class AddCategoryToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :category_id, :integer
    add_index  :experiences, :category_id
  end
end
