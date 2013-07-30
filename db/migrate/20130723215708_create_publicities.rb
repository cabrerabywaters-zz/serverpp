class CreatePublicities < ActiveRecord::Migration
  def change
    create_table :publicities do |t|
      t.attachment :image
      t.text       :comment
      t.string     :state
      t.integer    :event_id

      t.timestamps
    end

    add_index :publicities, :event_id
  end
end
