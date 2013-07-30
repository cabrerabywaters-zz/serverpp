class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.references :event
      t.attachment :image
      t.boolean :published

      t.timestamps
    end
    add_index :banners, :event_id
  end
end
