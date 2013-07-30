class CreateUserEcos < ActiveRecord::Migration
  def change
    create_table :user_ecos do |t|
      t.string :rut
      t.string :names
      t.string :first_lastname
      t.string :second_lastname
      t.string :nickname
      t.references :eco

      t.timestamps
    end
    add_index :user_ecos, :eco_id
  end
end
