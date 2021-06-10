class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true
      t.string :image_id
      t.timestamps
    end
  end
end
