module Admin
  class QuestStepsController < BaseController
    before_action :set_quest
    before_action :set_step, only: [ :show, :edit, :update, :destroy ]

    def new
      @quest_step = @quest.quest_steps.build(position: next_position, step_xp_reward: 10)
      3.times { @quest_step.answers.build }
    end

    def create
      @quest_step = @quest.quest_steps.build(step_params)
      if @quest_step.save
        redirect_to admin_quest_path(@quest), notice: "Étape ajoutée."
      else
        @quest_step.answers.build while @quest_step.answers.size < 3
        render :new, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
      @quest_step.answers.build while @quest_step.answers.size < 3
    end

    def update
      if @quest_step.update(step_params)
        redirect_to admin_quest_path(@quest), notice: "Étape mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @quest_step.destroy
      redirect_to admin_quest_path(@quest), notice: "Étape supprimée."
    end

    private

    def set_quest
      @quest = Quest.find(params[:quest_id])
    end

    def set_step
      @quest_step = @quest.quest_steps.find(params[:id])
    end

    def next_position
      (@quest.quest_steps.maximum(:position) || 0) + 1
    end

    def step_params
      params.require(:quest_step).permit(
        :position, :step_xp_reward, :gold_reward, :npc_id, :riddle_question,
        answers_attributes: [ :id, :content, :correct, :_destroy ]
      )
    end
  end
end
