class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      t.references :user
      t.string :name
      t.string :description

      t.datetime :birth_date

      t.boolean :enable, default: true

      t.timestamps
    end
  end
end
