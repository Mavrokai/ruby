class QuestProgressService
  def initialize(quest_progress)
    @progress = quest_progress
    @player = quest_progress.player
    @quest = quest_progress.quest
  end

  def complete_current_step!
    step = @progress.current_step
    return unless step

    xp = step.step_xp_reward + @player.step_xp_bonus
    @player.gain_experience(xp)
    @player.gain_gold(step.gold_reward)

    if @quest.last_step?(step.position)
      finish_quest!
    else
      advance_to_next_step!
    end
  end

  def advance_to_next_step!
    @progress.update!(current_step_position: @progress.current_step_position + 1, current_npc_health: nil)
  end

  def finish_quest!
    bonus = @quest.final_xp_reward + @player.step_xp_bonus
    @player.gain_experience(bonus)
    @player.gain_gold(@quest.gold_reward)
    @progress.update!(status: "completed", current_npc_health: nil)
  end

  def grant_reward!(item)
    return false unless item.is_a?(Item)
    return false unless @quest.reward_items.include?(item)
    InventoryItem.find_or_create_by!(player: @player, item: item)
    true
  end
end
