class QuestProgress < ApplicationRecord
  STATUSES = %w[active completed gameover].freeze

  belongs_to :player
  belongs_to :quest

  has_many :chat_messages, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }
  validates :current_step_position, numericality: { only_integer: true, greater_than: 0 }

  scope :active,    -> { where(status: "active") }
  scope :completed, -> { where(status: "completed") }

  after_create_commit  :broadcast_dashboard
  after_update_commit  :broadcast_dashboard
  after_destroy_commit :broadcast_dashboard

  def self.dashboard_active
    active.includes(:player, :quest).order(updated_at: :desc)
  end

  def broadcast_dashboard
    Turbo::StreamsChannel.broadcast_replace_to(
      "admin_dashboard",
      target: "admin-active-parties",
      partial: "admin/quest_progresses/active_parties",
      locals: { progresses: QuestProgress.dashboard_active }
    )
  end

  def current_step
    quest.step_at(current_step_position)
  end

  def in_combat?
    current_npc_health.present? && current_npc_health.positive?
  end

  def active?
    status == "active"
  end

  def completed?
    status == "completed"
  end

  def gameover?
    status == "gameover"
  end
end
