class MarketService
  Result = Struct.new(:success, :message, keyword_init: true) do
    def success?
      success
    end
  end

  def initialize(listing, buyer)
    @listing = listing
    @buyer = buyer
  end

  def purchase!
    return failure("Cette offre n'est plus disponible.") unless @listing.active?
    return failure("Vous ne pouvez pas acheter votre propre objet.") if own_listing?
    return failure("Or insuffisant.") unless @buyer.can_afford?(@listing.price)
    return failure("Vous possédez déjà cet objet.") if @buyer.owned_items.include?(@listing.item)

    ActiveRecord::Base.transaction do
      @buyer.debit_gold(@listing.price)
      seller = @listing.seller
      inventory_item = @listing.inventory_item
      if seller
        seller.credit_gold(@listing.price)
        @listing.update!(status: "sold", buyer: @buyer, inventory_item: nil)
        inventory_item&.destroy!
      end
      InventoryItem.create!(player: @buyer, item: @listing.item)
    end

    success("Vous avez acheté #{@listing.item.name} pour #{@listing.price} or.")
  rescue ActiveRecord::RecordInvalid => e
    failure("Achat impossible : #{e.message}")
  end

  private

  def own_listing?
    @listing.seller_id.present? && @listing.seller_id == @buyer.id
  end

  def success(message)
    Result.new(success: true, message: message)
  end

  def failure(message)
    Result.new(success: false, message: message)
  end
end
