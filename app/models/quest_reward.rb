class QuestReward < ApplicationRecord
  belongs_to :quest
  belongs_to :item

  validates :quest_id, uniqueness: { scope: :item_id }
end
