class InventoryItem < ApplicationRecord
  belongs_to :player
  belongs_to :item

  has_many :market_listings, dependent: :destroy
  has_one_attached :custom_image

  validates :player_id, uniqueness: { scope: :item_id }

  delegate :name, :slot, :slot_label, :force_bonus, :health_bonus, :xp_bonus, :description, to: :item

  def display_image
    custom_image.attached? ? custom_image : (item.image if item.image.attached?)
  end

  def listed?
    market_listings.exists?(status: "active")
  end

  def equipped?
    player.equipped_items.include?(item)
  end
end
