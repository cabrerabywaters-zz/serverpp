class AddApiUsernameAndApiPasswordToEfis < ActiveRecord::Migration
  def change
    add_column :efis, :api_username, :string
    add_column :efis, :api_password, :string
  end
end
