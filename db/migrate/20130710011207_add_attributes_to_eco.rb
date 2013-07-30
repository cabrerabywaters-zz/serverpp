class AddAttributesToEco < ActiveRecord::Migration
  def change
    add_column :ecos, :fancy_name,  :string
    add_column :ecos, :address,     :string
    add_column :ecos, :discount,    :float
    add_column :ecos, :fee,         :float
    add_column :ecos, :comuna_id,   :integer
    add_column :ecos, :admin_id,    :integer
    add_column :ecos, :description, :text

    add_index :ecos, :comuna_id
    add_index :ecos, :admin_id
  end
end
