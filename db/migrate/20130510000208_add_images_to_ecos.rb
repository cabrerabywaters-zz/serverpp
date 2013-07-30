class AddImagesToEcos < ActiveRecord::Migration
  def change
    add_column :ecos, :images, :boolean
  end
end
