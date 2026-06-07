class ChatMessage < ApplicationRecord
  SENDERS = %w[gm player].freeze

  belongs_to :quest_progress
  belongs_to :npc, optional: true

  validates :sender, inclusion: { in: SENDERS }
  validates :body, presence: true, length: { maximum: 1000 }

  after_create_commit :broadcast_to_party

  scope :chronological, -> { order(:created_at) }

  def from_gm?
    sender == "gm"
  end

  def author_label
    if from_gm?
      npc&.name || "Maître du jeu"
    else
      quest_progress.player.name
    end
  end

  private

  def broadcast_to_party
    broadcast_append_to(
      "party_chat_#{quest_progress_id}",
      target: "chat-messages-#{quest_progress_id}",
      partial: "chat_messages/message",
      locals: { message: self }
    )
  end
end
