class CreateNpcs < ActiveRecord::Migration[8.1]
  def change
    create_table :npcs do |t|
      t.string :name, null: false
      t.integer :max_health, null: false, default: 10
      t.integer :force, null: false, default: 5

      t.timestamps
    end
  end
end
