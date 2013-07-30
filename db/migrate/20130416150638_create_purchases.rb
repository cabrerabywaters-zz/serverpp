class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references  :exchange
      t.string      :rut
      t.string      :email

      t.timestamps
    end
    add_index :purchases, :exchange_id
  end
end
