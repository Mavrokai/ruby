class CreateQuestProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :quest_progresses do |t|
      t.references :player, null: false, foreign_key: true
      t.references :quest, null: false, foreign_key: true
      t.integer :current_step_position, null: false, default: 1
      t.string :status, null: false, default: "active"
      t.integer :current_npc_health

      t.timestamps
    end
    add_index :quest_progresses, [ :player_id, :quest_id ]
    add_index :quest_progresses, :status
  end
end
