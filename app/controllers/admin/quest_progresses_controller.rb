module Admin
  class QuestProgressesController < BaseController
    before_action :set_progress, only: [ :show, :send_message ]

    def index
      @active = QuestProgress.active.includes(:player, :quest).order(updated_at: :desc)
      @completed = QuestProgress.completed.includes(:player, :quest).order(updated_at: :desc).limit(20)
      @gameover = QuestProgress.where(status: "gameover").includes(:player, :quest).order(updated_at: :desc).limit(20)
    end

    def show
      @chat_messages = @progress.chat_messages.chronological
      @npcs = Npc.order(:name)
      @default_npc = @progress.current_step&.npc
    end

    def send_message
      message = @progress.chat_messages.new(
        sender: "gm",
        npc_id: params[:npc_id].presence,
        body: params[:body]
      )
      saved = message.save
      respond_to do |format|
        format.turbo_stream { head(saved ? :no_content : :unprocessable_entity) }
        format.html do
          redirect_to admin_quest_progress_path(@progress), alert: (saved ? nil : "Message vide.")
        end
      end
    end

    private

    def set_progress
      @progress = QuestProgress.find(params[:id])
    end
  end
end
