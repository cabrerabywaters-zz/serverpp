class RemoveClients < ActiveRecord::Migration
  def up
    drop_table :clients
  end

  def down
    create_table :clients do |t|
      t.string :rut
      t.string :name

      t.timestamps
    end
  end
end
