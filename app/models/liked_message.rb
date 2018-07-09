class LikedMessage < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :groupme_id, presence: true

  class << self
    def liked_own_message?(msg)
      msg[:favorited_by].include?(msg[:user_id])
    end

    def get_image(msg)
      msg[:attachments].each do |attachment|
        return attachment[:url] if attachment[:type] == 'image'
      end

      nil
    end
  end
end
