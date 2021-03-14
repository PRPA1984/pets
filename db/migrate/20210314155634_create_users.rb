class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :login
      t.string :password
      t.string :token

      t.boolean :enabled

      t.timestamps
    end
  end
end
