class CreateChatMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :chat_messages do |t|
      t.references :quest_progress, null: false, foreign_key: true
      t.references :npc, foreign_key: true
      t.string :sender, null: false, default: "gm"
      t.text :body, null: false

      t.timestamps
    end
    add_index :chat_messages, :created_at
  end
end
