class CreateValidImages < ActiveRecord::Migration
  def change
    create_table :valid_images do |t|
      t.attachment :image
      t.references :experience

      t.timestamps
    end
    add_index :valid_images, :experience_id
  end
end
