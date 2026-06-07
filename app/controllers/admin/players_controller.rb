module Admin
  class PlayersController < BaseController
    def index
      @players = Player.includes(:quest_progresses).order(:name)
    end

    def show
      @player = Player.find(params[:id])
      @progresses = @player.quest_progresses.includes(:quest).order(updated_at: :desc)
    end
  end
end
