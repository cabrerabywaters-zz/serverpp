class AddModClientToUserEfis < ActiveRecord::Migration
  def change
    add_column :user_efis, :mod_client, :boolean
  end
end
