require 'liked_message_checker'

class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_group
  before_action :call_groupme_api

  def incoming
    @messages.each do |message|
      LikedMessageChecker.check_message(message)
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
