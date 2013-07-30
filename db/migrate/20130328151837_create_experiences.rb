class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string      :name
      t.text        :details
      t.float       :amount
      t.string      :place
      t.attachment  :image
      t.datetime    :starting_at
      t.datetime    :ending_at
      t.string      :hour
      t.integer     :swaps
      t.references  :eco

      t.timestamps
    end
    add_index :experiences, :eco_id
  end
end
