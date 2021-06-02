class CreateProvinces < ActiveRecord::Migration[6.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.boolean :enabled
      t.timestamps
    end
  end
end
