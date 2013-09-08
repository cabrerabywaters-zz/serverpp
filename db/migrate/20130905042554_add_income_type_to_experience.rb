class AddIncomeTypeToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :income_type, :string
  end
end
