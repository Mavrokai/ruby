class QuestsController < ApplicationController
  before_action :require_player!

  def index
    @active_progress = current_player.active_quest_progress
    @quests = Quest.includes(:quest_steps).order(:title)
    @completed_quest_ids = current_player.quest_progresses.completed.pluck(:quest_id)
  end

  def show
    @quest = Quest.find(params[:id])
    @progress = current_player.quest_progresses.find_by(quest: @quest)
  end

  def start
    quest = Quest.find(params[:id])
    if current_player.active_quest_progress
      redirect_to game_menu_path, alert: "Vous avez déjà une quête en cours."
      return
    end
    if quest.quest_steps.empty?
      redirect_to quests_path, alert: "Cette quête n'a pas encore d'étapes."
      return
    end

    progress = current_player.quest_progresses.find_or_initialize_by(quest: quest)
    progress.assign_attributes(status: "active", current_step_position: 1, current_npc_health: nil)
    current_player.heal_full
    progress.save!
    redirect_to quest_progress_path(progress)
  end
end
