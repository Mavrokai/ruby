class QuestStep < ApplicationRecord
  belongs_to :quest, inverse_of: :quest_steps
  belongs_to :npc

  has_many :answers, class_name: "QuestStepAnswer", dependent: :destroy, inverse_of: :quest_step

  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: ->(attrs) { attrs[:content].blank? }

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :step_xp_reward, :gold_reward, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :riddle_question, presence: true
  validate :must_have_one_correct_answer

  def correct_answer
    answers.find_by(correct: true)
  end

  def correct_answer?(answer_id)
    answers.exists?(id: answer_id, correct: true)
  end

  private

  def must_have_one_correct_answer
    return if answers.empty?
    errors.add(:answers, "doivent contenir exactement une bonne réponse") unless answers.count(&:correct) == 1
  end
end
