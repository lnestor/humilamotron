class User < ApplicationRecord
  has_many :liked_messages, dependent: :destroy

  validates :name, :groupme_id, presence: true
end
