class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.string :picture
      t.boolean :enabled
      t.references :province
      t.references :user
      t.timestamps
    end
  end
end
