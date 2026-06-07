class QuestProgressesController < ApplicationController
  before_action :require_player!
  before_action :set_progress

  def show
    redirect_to gameover_quest_progress_path(@progress) and return if @progress.gameover?
    redirect_to reward_quest_progress_path(@progress)   and return if @progress.completed?
    @chat_messages = @progress.chat_messages.chronological
  end

  def send_message
    message = @progress.chat_messages.new(sender: "player", body: params[:body])
    saved = message.save
    respond_to do |format|
      format.turbo_stream { head(saved ? :no_content : :unprocessable_entity) }
      format.html do
        redirect_to quest_progress_path(@progress), alert: (saved ? nil : "Message vide.")
      end
    end
  end

  def answer
    return redirect_to(quest_progress_path(@progress)) if @progress.in_combat?

    step = @progress.current_step
    if step.correct_answer?(params[:answer_id])
      QuestProgressService.new(@progress).complete_current_step!
      redirect_after_step
    else
      flash[:alert] = "Mauvaise réponse !"
      redirect_to quest_progress_path(@progress)
    end
  end

  def start_combat
    CombatService.new(@progress).start!
    redirect_to quest_progress_path(@progress)
  end

  def attack
    return redirect_to(quest_progress_path(@progress)) unless @progress.in_combat?

    result = CombatService.new(@progress).player_attack!
    flash[:combat_log] = result[:log]

    case result[:outcome]
    when :npc_defeated
      QuestProgressService.new(@progress.reload).complete_current_step!
      redirect_after_step
    when :player_defeated
      redirect_to gameover_quest_progress_path(@progress)
    else
      redirect_to quest_progress_path(@progress)
    end
  end

  def flee
    CombatService.new(@progress).flee!
    redirect_to quest_progress_path(@progress)
  end

  def reward
    redirect_to(quest_progress_path(@progress)) and return unless @progress.completed?
    @reward_items = @progress.quest.reward_items
  end

  def choose_reward
    redirect_to(quest_progress_path(@progress)) and return unless @progress.completed?
    item = Item.find_by(id: params[:item_id])
    if QuestProgressService.new(@progress).grant_reward!(item)
      redirect_to game_menu_path, notice: "Vous avez reçu : #{item.name} !"
    else
      redirect_to reward_quest_progress_path(@progress), alert: "Récompense invalide."
    end
  end

  def gameover
    redirect_to(quest_progress_path(@progress)) unless @progress.gameover?
  end

  def retry
    return redirect_to(quest_progress_path(@progress)) unless @progress.gameover?

    current_player.heal_full
    @progress.update!(status: "active", current_step_position: 1, current_npc_health: nil)
    redirect_to quest_progress_path(@progress)
  end

  private

  def set_progress
    @progress = current_player.quest_progresses.find(params[:id])
  end

  def redirect_after_step
    @progress.reload
    if @progress.completed?
      redirect_to reward_quest_progress_path(@progress)
    elsif @progress.gameover?
      redirect_to gameover_quest_progress_path(@progress)
    else
      redirect_to quest_progress_path(@progress)
    end
  end
end
