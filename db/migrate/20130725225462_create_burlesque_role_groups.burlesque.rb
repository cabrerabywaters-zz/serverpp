# This migration comes from burlesque (originally 20130725223204)
class CreateBurlesqueRoleGroups < ActiveRecord::Migration
  def change
    create_table :burlesque_role_groups do |t|
      t.references :role
      t.references :group

      t.timestamps
    end
    add_index :burlesque_role_groups, :role_id
    add_index :burlesque_role_groups, :group_id
  end
end
