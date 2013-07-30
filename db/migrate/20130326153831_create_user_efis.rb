class CreateUserEfis < ActiveRecord::Migration
  def change
    create_table :user_efis do |t|
      t.string      :rut
      t.string      :names
      t.string      :first_lastname
      t.string      :second_lastname
      t.string      :nickname
      t.references  :efi

      t.timestamps
    end

    add_index :user_efis, :rut
    add_index :user_efis, :efi_id
  end
end
