module Admin
  class QuestsController < BaseController
    before_action :set_quest, only: [ :show, :edit, :update, :destroy ]

    def index
      @quests = Quest.includes(:quest_steps, :reward_items).order(:title)
    end

    def show
    end

    def new
      @quest = Quest.new
    end

    def create
      @quest = Quest.new(quest_params)
      if @quest.save
        redirect_to admin_quest_path(@quest), notice: "Quête créée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @quest.update(quest_params)
        redirect_to admin_quest_path(@quest), notice: "Quête mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @quest.destroy
      redirect_to admin_quests_path, notice: "Quête supprimée."
    end

    private

    def set_quest
      @quest = Quest.find(params[:id])
    end

    def quest_params
      params.require(:quest).permit(:title, :description, :final_xp_reward, :gold_reward, reward_item_ids: [])
    end
  end
end
