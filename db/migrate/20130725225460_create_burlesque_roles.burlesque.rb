# This migration comes from burlesque (originally 20130725210428)
class CreateBurlesqueRoles < ActiveRecord::Migration
  def change
    create_table :burlesque_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
