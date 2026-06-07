module Admin
  class MarketListingsController < BaseController
    def index
      @shop_listings = MarketListing.shop.active.includes(:item).order(:price)
      @player_listings = MarketListing.from_players.includes(:item, :seller, :buyer).order(updated_at: :desc).limit(50)
    end

    def new
      @listing = MarketListing.new(price: 10)
    end

    def create
      @listing = MarketListing.new(shop_params.merge(status: "active", seller: nil, inventory_item: nil))
      if @listing.save
        redirect_to admin_market_listings_path, notice: "Objet ajouté à la boutique."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      MarketListing.find(params[:id]).destroy
      redirect_to admin_market_listings_path, notice: "Offre retirée."
    end

    private

    def shop_params
      params.require(:market_listing).permit(:item_id, :price)
    end
  end
end
