class MarketListingsController < ApplicationController
  before_action :require_player!

  def index
    @shop_listings = MarketListing.active.shop.includes(item: { image_attachment: :blob }).order(:price)
    @player_listings = MarketListing.active.from_players
                                    .where.not(seller_id: current_player.id)
                                    .includes(:seller, item: { image_attachment: :blob }).order(:price)
    @my_listings = current_player.market_listings.active.includes(:item)
  end

  def new
    @inventory_item = current_player.inventory_items.find_by(id: params[:inventory_item_id])
    redirect_to(game_inventory_path, alert: "Objet introuvable.") and return unless @inventory_item
    @listing = MarketListing.new(item: @inventory_item.item, inventory_item: @inventory_item, price: 10)
  end

  def create
    inventory_item = current_player.inventory_items.find_by(id: params[:inventory_item_id])
    return redirect_to(game_inventory_path, alert: "Objet introuvable.") if inventory_item.nil?
    return redirect_to(game_inventory_path, alert: "Déséquipez l'objet avant de le vendre.") if inventory_item.equipped?
    return redirect_to(market_listings_path, alert: "Cet objet est déjà en vente.") if inventory_item.listed?

    listing = MarketListing.new(
      item: inventory_item.item,
      inventory_item: inventory_item,
      seller: current_player,
      price: params[:price],
      status: "active"
    )
    if listing.save
      redirect_to market_listings_path, notice: "#{inventory_item.name} mis en vente pour #{listing.price} or."
    else
      redirect_to game_inventory_path, alert: listing.errors.full_messages.to_sentence
    end
  end

  def destroy
    listing = current_player.market_listings.find_by(id: params[:id])
    if listing&.active?
      listing.update(status: "cancelled")
      redirect_to market_listings_path, notice: "Vente annulée."
    else
      redirect_to market_listings_path, alert: "Impossible d'annuler cette vente."
    end
  end

  def buy
    listing = MarketListing.find(params[:id])
    result = MarketService.new(listing, current_player).purchase!
    redirect_to market_listings_path, (result.success? ? :notice : :alert) => result.message
  end
end
