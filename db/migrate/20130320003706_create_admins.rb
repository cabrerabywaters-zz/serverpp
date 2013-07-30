class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :rut
      t.string :names
      t.string :first_lastname
      t.string :second_lastname
      t.string :nickname

      t.timestamps
    end
  end
end
