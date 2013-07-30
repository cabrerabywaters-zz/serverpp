class AddComunaToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :chilean_cities_comuna_id, :integer
    add_index :experiences,  :chilean_cities_comuna_id
  end
end
