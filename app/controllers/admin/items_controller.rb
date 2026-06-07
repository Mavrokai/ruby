module Admin
  class ItemsController < BaseController
    before_action :set_item, only: [ :show, :edit, :update, :destroy ]

    def index
      @items = Item.order(:slot, :name)
    end

    def show
    end

    def new
      @item = Item.new(slot: "hat")
    end

    def create
      @item = Item.new(item_params)
      if @item.save
        redirect_to admin_items_path, notice: "Objet créé."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @item.update(item_params)
        redirect_to admin_items_path, notice: "Objet mis à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @item.destroy
      redirect_to admin_items_path, notice: "Objet supprimé."
    end

    private

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :slot, :force_bonus, :health_bonus, :xp_bonus, :description, :image)
    end
  end
end
