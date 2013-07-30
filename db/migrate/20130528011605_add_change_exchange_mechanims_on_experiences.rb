class AddChangeExchangeMechanimsOnExperiences < ActiveRecord::Migration
  def up
    rename_column :experiences, :exchange_mechanism_id, :exchange_mechanism
    change_column :experiences, :exchange_mechanism, :string
  end

  def down
    rename_column :experiences, :exchange_mechanism, :exchange_mechanism_id
    change_column :experiences, :exchange_mechanism_id, :integer
  end
end
