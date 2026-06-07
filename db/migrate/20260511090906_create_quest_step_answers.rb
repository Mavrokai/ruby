class CreateQuestStepAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :quest_step_answers do |t|
      t.references :quest_step, null: false, foreign_key: true
      t.string :content, null: false
      t.boolean :correct, null: false, default: false

      t.timestamps
    end
  end
end
