class CreateQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :quests do |t|
      t.string :title, null: false
      t.text :description
      t.integer :final_xp_reward, null: false, default: 50

      t.timestamps
    end
  end
end
