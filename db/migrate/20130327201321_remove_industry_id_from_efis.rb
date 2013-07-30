class RemoveIndustryIdFromEfis < ActiveRecord::Migration
  def up
    remove_index  :efis, :industry_id
    remove_column :efis, :industry_id
  end

  def down
    add_column :efis, :industry_id, :integer
    add_index  :efis, :industry_id
  end
end
