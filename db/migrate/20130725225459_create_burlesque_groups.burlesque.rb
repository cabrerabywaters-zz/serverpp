# This migration comes from burlesque (originally 20130725210208)
class CreateBurlesqueGroups < ActiveRecord::Migration
  def change
    create_table :burlesque_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
