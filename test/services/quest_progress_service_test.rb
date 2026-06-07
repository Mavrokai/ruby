require "test_helper"

class QuestProgressServiceTest < ActiveSupport::TestCase
  def setup
    @player = players(:alice)
    @quest = quests(:forest)
    @progress = QuestProgress.create!(player: @player, quest: @quest, current_step_position: 1)
  end

  test "complete_current_step advances to next step on intermediate step" do
    QuestProgressService.new(@progress).complete_current_step!
    assert_equal 2, @progress.reload.current_step_position
    assert_equal "active", @progress.status
  end

  test "complete_current_step finishes quest on last step" do
    @progress.update!(current_step_position: 2)
    QuestProgressService.new(@progress).complete_current_step!
    assert_equal "completed", @progress.reload.status
  end

  test "complete_current_step grants xp" do
    initial_xp = @player.experience
    QuestProgressService.new(@progress).complete_current_step!
    assert_operator @player.reload.experience, :>, initial_xp
  end

  test "grant_reward adds item to inventory when item is part of quest rewards" do
    item = items(:short_sword)
    @quest.reward_items << item
    @progress.update!(status: "completed")
    assert QuestProgressService.new(@progress).grant_reward!(item)
    assert @player.reload.owned_items.include?(item)
  end

  test "grant_reward rejects item not in quest rewards" do
    @progress.update!(status: "completed")
    refute QuestProgressService.new(@progress).grant_reward!(items(:short_sword))
  end
end
