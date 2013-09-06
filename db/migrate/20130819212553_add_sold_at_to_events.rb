class AddSoldAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sold_at, :datetime
  end
end
