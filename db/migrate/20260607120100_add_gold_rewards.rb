class AddGoldRewards < ActiveRecord::Migration[8.1]
  def change
    add_column :quests, :gold_reward, :integer, null: false, default: 20
    add_column :quest_steps, :gold_reward, :integer, null: false, default: 5
  end
end
