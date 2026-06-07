require "test_helper"

class QuestStepTest < ActiveSupport::TestCase
  test "correct_answer? returns true for the correct answer" do
    step = quest_steps(:step_one)
    assert step.correct_answer?(quest_step_answers(:step_one_correct).id)
  end

  test "correct_answer? returns false for a wrong answer" do
    step = quest_steps(:step_one)
    refute step.correct_answer?(quest_step_answers(:step_one_wrong).id)
  end
end
