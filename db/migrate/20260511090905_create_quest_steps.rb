class CreateQuestSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :quest_steps do |t|
      t.references :quest, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :step_xp_reward, null: false, default: 10
      t.references :npc, null: false, foreign_key: true
      t.string :riddle_question, null: false

      t.timestamps
    end
    add_index :quest_steps, [ :quest_id, :position ], unique: true
  end
end
