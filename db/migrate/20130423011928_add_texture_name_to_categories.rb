class AddTextureNameToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :texture_name, :string
  end
end
