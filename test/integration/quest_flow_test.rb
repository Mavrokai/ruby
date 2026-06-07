require "test_helper"

class QuestFlowTest < ActionDispatch::IntegrationTest
  def sign_in_as(player)
    post choose_players_path, params: { player_id: player.id }
  end

  test "player starts a quest and answers the first riddle correctly" do
    player = players(:alice)
    sign_in_as(player)

    quest = quests(:forest)
    assert_difference "QuestProgress.count", 1 do
      post start_quest_path(quest)
    end

    progress = QuestProgress.last
    assert_redirected_to quest_progress_path(progress)

    post answer_quest_progress_path(progress), params: { answer_id: quest_step_answers(:step_one_correct).id }
    progress.reload
    assert_equal 2, progress.current_step_position
  end

  test "wrong answer keeps the player on the same step" do
    player = players(:alice)
    sign_in_as(player)
    post start_quest_path(quests(:forest))
    progress = QuestProgress.last

    post answer_quest_progress_path(progress), params: { answer_id: quest_step_answers(:step_one_wrong).id }
    assert_equal 1, progress.reload.current_step_position
    assert_equal "active", progress.status
  end

  test "completing the last step finishes the quest" do
    player = players(:alice)
    sign_in_as(player)
    post start_quest_path(quests(:forest))
    progress = QuestProgress.last

    post answer_quest_progress_path(progress), params: { answer_id: quest_step_answers(:step_one_correct).id }
    post answer_quest_progress_path(progress), params: { answer_id: quest_step_answers(:step_boss_correct).id }

    progress.reload
    assert_equal "completed", progress.status
    assert_redirected_to reward_quest_progress_path(progress)
  end

  test "combat with a powerful npc triggers gameover" do
    player = players(:alice)
    sign_in_as(player)
    post start_quest_path(quests(:forest))
    progress = QuestProgress.last
    progress.update!(current_step_position: 2)

    post start_combat_quest_progress_path(progress)
    post attack_quest_progress_path(progress)

    progress.reload
    assert_equal "gameover", progress.status
    assert_redirected_to gameover_quest_progress_path(progress)
  end
end
