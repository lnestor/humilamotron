class Group < ApplicationRecord
  validates :groupme_id, :name, presence: true
end
