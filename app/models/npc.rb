class Npc < ApplicationRecord
  has_many :quest_steps, dependent: :restrict_with_error

  has_one_attached :avatar

  validates :name, presence: true
  validates :max_health, :force,
            numericality: { only_integer: true, greater_than: 0 }
end
