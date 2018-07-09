require 'liked_message_checker'

class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_group
  before_action :call_groupme_api

  def incoming
    @messages.each do |msg|
      next if !LikedMessage.liked_own_message?(msg)
      next if LikedMessage.exists?(groupme_id: msg[:id])

      if !User.exists?(groupme_id: msg[:user_id])
        User.create!(groupme_id: msg[:user_id], name: msg[:name])
      end

      LikedMessage.create!(
        user: User.find_by_groupme_id(msg[:user_id]),
        content: msg[:text],
        group: Group.find_by_groupme_id(msg[:group_id]),
        groupme_id: msg[:id],
        image_url: LikedMessage.get_image(msg),
        created_at: Time.at(msg[:created_at])
      )
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
end
