require "test_helper"

class CombatServiceTest < ActiveSupport::TestCase
  def setup
    @player = players(:alice)
    @quest = quests(:forest)
    @progress = QuestProgress.create!(player: @player, quest: @quest, current_step_position: 1)
  end

  test "start! initializes npc current health" do
    service = CombatService.new(@progress)
    service.start!
    assert_equal @progress.current_step.npc.max_health, @progress.reload.current_npc_health
  end

  test "player attack defeats weak npc in one hit" do
    @progress.update!(current_npc_health: 5)
    result = CombatService.new(@progress).player_attack!
    assert_equal :npc_defeated, result[:outcome]
    assert_equal 0, @progress.reload.current_npc_health
  end

  test "player attack does not defeat npc, npc counter-attacks" do
    @progress.update!(current_npc_health: 100)
    result = CombatService.new(@progress).player_attack!
    assert_equal :ongoing, result[:outcome]
    assert_equal 100 - @player.total_force, @progress.reload.current_npc_health
    assert_operator @player.reload.current_health, :<, Player::STARTING_HEALTH
  end

  test "npc kills weak player triggers gameover" do
    @player.update!(current_health: 1)
    @progress.update!(current_step_position: 2, current_npc_health: 1000)
    result = CombatService.new(@progress).player_attack!
    assert_equal :player_defeated, result[:outcome]
    assert_equal "gameover", @progress.reload.status
    assert_equal 0, @player.reload.current_health
  end
end
