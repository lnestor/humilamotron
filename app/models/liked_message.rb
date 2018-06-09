class LikedMessage < ApplicationRecord
  belongs_to :user

  validates :content, :groupme_id, :group_groupme_id, presence: true
end
