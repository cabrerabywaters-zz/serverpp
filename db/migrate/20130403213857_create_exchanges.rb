class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :points
      t.integer :cash
      t.references :event

      t.timestamps
    end
    add_index :exchanges, :event_id
  end
end
