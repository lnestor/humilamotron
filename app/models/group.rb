class Group < ApplicationRecord
  has_many :liked_messages

  validates :groupme_id, :name, presence: true
end
