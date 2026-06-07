class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.integer :level, null: false, default: 1
      t.integer :experience, null: false, default: 0
      t.integer :max_health, null: false, default: 10
      t.integer :current_health, null: false, default: 10
      t.integer :force, null: false, default: 10
      t.integer :available_stat_points, null: false, default: 10

      t.timestamps
    end
    add_index :players, :name, unique: true
  end
end
