class LikedMessage < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :content, :groupme_id, presence: true
end
