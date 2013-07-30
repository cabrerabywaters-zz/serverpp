class ChangeExchangeMechanismToTextIntoExperiences < ActiveRecord::Migration
  def up
    change_column :experiences, :exchange_mechanism, :text
  end

  def down
    change_column :experiences, :exchange_mechanism, :string
  end
end
