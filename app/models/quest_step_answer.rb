class QuestStepAnswer < ApplicationRecord
  belongs_to :quest_step, inverse_of: :answers

  validates :content, presence: true
end
