module Admin
  class NpcsController < BaseController
    before_action :set_npc, only: [ :show, :edit, :update, :destroy ]

    def index
      @npcs = Npc.order(:name)
    end

    def show
    end

    def new
      @npc = Npc.new(max_health: 10, force: 5)
    end

    def create
      @npc = Npc.new(npc_params)
      if @npc.save
        redirect_to admin_npcs_path, notice: "PNJ créé."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @npc.update(npc_params)
        redirect_to admin_npcs_path, notice: "PNJ mis à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @npc.destroy
        redirect_to admin_npcs_path, notice: "PNJ supprimé."
      else
        redirect_to admin_npcs_path, alert: "Impossible de supprimer ce PNJ (utilisé dans une étape)."
      end
    end

    private

    def set_npc
      @npc = Npc.find(params[:id])
    end

    def npc_params
      params.require(:npc).permit(:name, :max_health, :force, :avatar)
    end
  end
end
