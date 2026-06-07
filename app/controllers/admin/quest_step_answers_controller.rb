module Admin
  class QuestStepAnswersController < BaseController
    before_action :set_quest_and_step
    before_action :set_answer, only: [ :edit, :update, :destroy ]

    def new
      @answer = @quest_step.answers.build
    end

    def create
      @answer = @quest_step.answers.build(answer_params)
      if @answer.save
        redirect_to admin_quest_quest_step_path(@quest, @quest_step), notice: "Réponse ajoutée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @answer.update(answer_params)
        redirect_to admin_quest_quest_step_path(@quest, @quest_step), notice: "Réponse mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @answer.destroy
      redirect_to admin_quest_quest_step_path(@quest, @quest_step), notice: "Réponse supprimée."
    end

    private

    def set_quest_and_step
      @quest = Quest.find(params[:quest_id])
      @quest_step = @quest.quest_steps.find(params[:quest_step_id])
    end

    def set_answer
      @answer = @quest_step.answers.find(params[:id])
    end

    def answer_params
      params.require(:quest_step_answer).permit(:content, :correct)
    end
  end
end
