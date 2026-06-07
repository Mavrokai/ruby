class Item < ApplicationRecord
  SLOTS = %w[
    hat
    cape
    chest
    weapon
    weapon_2h
    staff
    shield
    legs
    boots
    gloves
    belt
  ].freeze

  has_many :inventory_items, dependent: :destroy
  has_many :players, through: :inventory_items
  has_many :quest_rewards, dependent: :destroy
  has_many :quests_as_reward, through: :quest_rewards, source: :quest

  has_one_attached :image

  validates :name, presence: true
  validates :slot, presence: true, inclusion: { in: SLOTS }
  validates :force_bonus, :health_bonus, :xp_bonus,
            numericality: { only_integer: true }

  scope :hats,    -> { where(slot: "hat") }
  scope :capes,   -> { where(slot: "cape") }
  scope :chests,  -> { where(slot: "chest") }
  scope :weapons, -> { where(slot: "weapon") }
  scope :weapons_2h, -> { where(slot: "weapon_2h") }
  scope :staves,  -> { where(slot: "staff") }
  scope :shields, -> { where(slot: "shield") }
  scope :legs,    -> { where(slot: "legs") }
  scope :boots,   -> { where(slot: "boots") }
  scope :gloves,  -> { where(slot: "gloves") }
  scope :belts,   -> { where(slot: "belt") }

  def slot_label
    case slot
    when "hat"        then "Tête"
    when "cape"       then "Cape"
    when "chest"      then "Armure"
    when "weapon"     then "Arme (1 main)"
    when "weapon_2h"  then "Arme (2 mains)"
    when "staff"      then "Bâton"
    when "shield"     then "Bouclier"
    when "legs"       then "Jambières"
    when "boots"      then "Bottes"
    when "gloves"     then "Gants"
    when "belt"       then "Ceinture"
    else slot.to_s.titleize
    end
  end
end
