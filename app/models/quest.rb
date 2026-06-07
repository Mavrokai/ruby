class Quest < ApplicationRecord
  has_many :quest_steps, -> { order(:position) }, dependent: :destroy, inverse_of: :quest
  has_many :quest_rewards, dependent: :destroy
  has_many :reward_items, through: :quest_rewards, source: :item
  has_many :quest_progresses, dependent: :destroy

  accepts_nested_attributes_for :quest_steps, allow_destroy: true

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :final_xp_reward, :gold_reward, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def step_at(position)
    quest_steps.find_by(position: position)
  end

  def last_step?(position)
    position.to_i >= quest_steps.maximum(:position).to_i
  end
end
