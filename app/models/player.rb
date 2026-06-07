class Player < ApplicationRecord
  STARTING_LEVEL = 1
  STARTING_FORCE = 10
  STARTING_HEALTH = 10
  STARTING_STAT_POINTS = 10
  XP_FOR_LEVEL = 100
  POINTS_PER_LEVEL = 3

  # slot_key => colonne d'équipement ActiveRecord
  SLOT_TO_EQUIPMENT = {
    "hat"        => :equipped_hat,
    "cape"       => :equipped_cape,
    "chest"      => :equipped_chest,
    "weapon"     => :equipped_weapon,
    "weapon_2h"  => :equipped_weapon_2h,
    "staff"      => :equipped_staff,
    "shield"     => :equipped_shield,
    "legs"       => :equipped_legs,
    "boots"      => :equipped_boots,
    "gloves"     => :equipped_gloves,
    "belt"       => :equipped_belt
  }.freeze

  EQUIPMENT_FIELDS = SLOT_TO_EQUIPMENT.values.freeze

  # Pour les vues : [ clé slot, reader, libellé court ]
  EQUIPMENT_SLOT_ROWS = [
    [ "hat",       :equipped_hat,         "Tête" ],
    [ "cape",      :equipped_cape,        "Cape" ],
    [ "chest",     :equipped_chest,       "Armure" ],
    [ "weapon",    :equipped_weapon,      "Arme (1 main)" ],
    [ "weapon_2h", :equipped_weapon_2h,   "Arme (2 mains)" ],
    [ "staff",     :equipped_staff,       "Bâton / magie" ],
    [ "shield",    :equipped_shield,      "Bouclier" ],
    [ "legs",      :equipped_legs,        "Jambières" ],
    [ "boots",     :equipped_boots,       "Bottes" ],
    [ "gloves",    :equipped_gloves,      "Gants" ],
    [ "belt",      :equipped_belt,        "Ceinture" ]
  ].freeze

  belongs_to :equipped_hat,         class_name: "Item", optional: true
  belongs_to :equipped_cape,        class_name: "Item", optional: true
  belongs_to :equipped_chest,       class_name: "Item", optional: true
  belongs_to :equipped_weapon,      class_name: "Item", optional: true
  belongs_to :equipped_weapon_2h,   class_name: "Item", optional: true
  belongs_to :equipped_staff,       class_name: "Item", optional: true
  belongs_to :equipped_shield,      class_name: "Item", optional: true
  belongs_to :equipped_legs,        class_name: "Item", optional: true
  belongs_to :equipped_boots,       class_name: "Item", optional: true
  belongs_to :equipped_gloves,      class_name: "Item", optional: true
  belongs_to :equipped_belt,        class_name: "Item", optional: true

  DEFAULT_ACCENT_COLOR = "#d4a44a".freeze

  has_many :inventory_items, dependent: :destroy
  has_many :owned_items, through: :inventory_items, source: :item
  has_many :quest_progresses, dependent: :destroy
  has_many :quests, through: :quest_progresses
  has_many :market_listings, foreign_key: :seller_id, dependent: :destroy, inverse_of: :seller

  has_one_attached :avatar

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :level, :experience, :max_health, :current_health, :force, :available_stat_points, :gold,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :accent_color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: "doit être une couleur hexadécimale" }
  validate :health_within_max

  after_update_commit :broadcast_dashboard_parties

  def equipped_items
    EQUIPMENT_FIELDS.map { |f| public_send(f) }.compact
  end

  def total_force
    force + equipped_items.sum(&:force_bonus)
  end

  def total_max_health
    max_health + equipped_items.sum(&:health_bonus)
  end

  def step_xp_bonus
    equipped_items.sum(&:xp_bonus)
  end

  def active_quest_progress
    quest_progresses.find_by(status: "active")
  end

  def equip(item)
    return false unless item.is_a?(Item) && owned_items.include?(item)

    field = SLOT_TO_EQUIPMENT[item.slot]
    return false unless field

    update(field => item)
  end

  def unequip(slot)
    field = SLOT_TO_EQUIPMENT[slot.to_s]
    return false unless field

    update(field => nil)
  end

  def gain_experience(amount)
    return if amount.to_i <= 0
    self.experience += amount.to_i
    while experience >= XP_FOR_LEVEL
      self.experience -= XP_FOR_LEVEL
      self.level += 1
      self.available_stat_points += POINTS_PER_LEVEL
    end
    save!
  end

  def spend_stat_points(force_points:, health_points:)
    force_points = force_points.to_i
    health_points = health_points.to_i
    total = force_points + health_points
    return false if total <= 0 || total > available_stat_points || force_points.negative? || health_points.negative?

    self.force += force_points
    self.max_health += health_points
    self.current_health += health_points
    self.available_stat_points -= total
    save
  end

  def alive?
    current_health.positive?
  end

  def heal_full
    update(current_health: total_max_health)
  end

  def can_afford?(amount)
    gold >= amount.to_i
  end

  def credit_gold(amount)
    amount = amount.to_i
    return if amount <= 0
    update!(gold: gold + amount)
  end

  def debit_gold(amount)
    amount = amount.to_i
    return false if amount <= 0 || !can_afford?(amount)
    update!(gold: gold - amount)
    true
  end

  def gain_gold(amount)
    credit_gold(amount)
  end

  private

  def broadcast_dashboard_parties
    return unless saved_change_to_current_health? || saved_change_to_level? || saved_change_to_gold?
    Turbo::StreamsChannel.broadcast_replace_to(
      "admin_dashboard",
      target: "admin-active-parties",
      partial: "admin/quest_progresses/active_parties",
      locals: { progresses: QuestProgress.dashboard_active }
    )
  end

  def health_within_max
    return if current_health.nil? || max_health.nil?
    errors.add(:current_health, "ne peut pas dépasser les PV max") if current_health > max_health + equipped_items.sum(&:health_bonus)
  end
end
