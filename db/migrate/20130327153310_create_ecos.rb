class CreateEcos < ActiveRecord::Migration
  def change
    create_table :ecos do |t|
      t.string      :name
      t.string      :rut
      t.attachment  :logo
      t.string      :webpage

      t.timestamps
    end

    add_index :ecos, :rut
  end
end
