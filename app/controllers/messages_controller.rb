class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_group
  before_action :call_groupme_api

  def incoming
    @messages.each do |message|
      if !LikedMessage.exists?(groupme_id: message[:id])
        message[:favorited_by].each do |like_id|
          if like_id == message[:user_id]
            if !User.exists?(groupme_id: message[:user_id])
              User.create!(groupme_id: message[:user_id], name: message[:name])
            end

            LikedMessage.create!(user: User.find_by_groupme_id(message[:user_id]), content: message[:text], group: Group.find_by_groupme_id(params[:group_id]), groupme_id: message[:id], image_url: message_image(message))
          end
        end
      end
    end
  end

  private

  def messages_url(group_id)
    "https://api.groupme.com/v3/groups/#{group_id}/messages?token=#{ENV['GROUPME_ACCESS_TOKEN']}&limit=10"
  end

  def authenticate_group
    if !Group.exists?(groupme_id: params[:group_id])
      head :unauthorized
    end
  end

  def call_groupme_api
    response = Faraday.get(messages_url(params[:group_id]))
    @messages = JSON.parse(response.body, symbolize_names: true)[:response][:messages]
  end

  def message_image(msg)
    msg[:attachments].each do |attachment|
      if attachment[:type] == 'image'
        return attachment[:url]
      end
    end
    nil
  end
end
