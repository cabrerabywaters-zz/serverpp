class AddPercentageToIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :percentage, :float
  end
end
