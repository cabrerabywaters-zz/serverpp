class CreateEfis < ActiveRecord::Migration
  def change
    create_table :efis do |t|
      t.string      :rut
      t.string      :name
      t.references  :industry
      t.attachment  :logo

      t.timestamps
    end

    add_index :efis, :rut
    add_index :efis, :industry_id
  end
end
