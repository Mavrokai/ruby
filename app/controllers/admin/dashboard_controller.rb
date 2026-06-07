module Admin
  class DashboardController < BaseController
    def index
      @quests_count = Quest.count
      @items_count = Item.count
      @npcs_count = Npc.count
      @players_count = Player.count
    end
  end
end
