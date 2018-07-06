class MessageUploadsController < ApplicationController
  before_action :authenticate_admin!

  def new
  end

  def create
    messages = JSON.parse(params[:file].read, symbolize_names: true)

    messages.each do |message|
      if !LikedMessage.exists?(groupme_id: message[:id])
        message[:favorited_by].each do |like_id|
          if like_id == message[:user_id]
            if !User.exists?(groupme_id: message[:user_id])
              User.create!(groupme_id: message[:user_id], name: message[:name])
            end

            LikedMessage.create!(user: User.find_by_groupme_id(message[:user_id]), content: message[:text], group: Group.find_by_groupme_id(message[:group_id]), groupme_id: message[:id], image_url: message_image(message), created_at: Time.at(message[:created_at]))
          end
        end
      end
    end
  end

  private

  def message_image(msg)
    msg[:attachments].each do |attachment|
      if attachment[:type] == 'image'
        return attachment[:url]
      end
    end
    nil
  end
end
