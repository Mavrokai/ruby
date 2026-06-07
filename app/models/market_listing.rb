class MarketListing < ApplicationRecord
  STATUSES = %w[active sold cancelled].freeze

  belongs_to :item
  belongs_to :seller, class_name: "Player", optional: true
  belongs_to :buyer, class_name: "Player", optional: true
  belongs_to :inventory_item, optional: true

  validates :status, inclusion: { in: STATUSES }
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :player_listing_requires_inventory_item

  scope :active,       -> { where(status: "active") }
  scope :shop,         -> { where(seller_id: nil) }
  scope :from_players, -> { where.not(seller_id: nil) }

  def shop?
    seller_id.nil?
  end

  def active?
    status == "active"
  end

  def seller_name
    shop? ? "Hôtel des ventes" : seller&.name
  end

  private

  def player_listing_requires_inventory_item
    return if shop? || status != "active"
    errors.add(:inventory_item, "est requis pour une vente de joueur") if inventory_item.nil?
  end
end
