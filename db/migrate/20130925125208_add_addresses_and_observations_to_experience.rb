class AddAddressesAndObservationsToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :addresses, :text
    add_column :experiences, :observations, :text
  end
end
