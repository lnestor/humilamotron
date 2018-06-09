class MessagesController < ApplicationController
  def incoming
    response = Faraday.get("https://api.groupme.com/v3/groups/#{params[:group_id]}/messages?token=#{ENV['access_token']}&limit=10")
    messages = JSON.parse(response.body, symbolize_names: true)[:response][:messages]

    messages.each do |message|
      if !LikedMessage.exists?(groupme_id: message[:id])
        message[:favorited_by].each do |like_id|
          if like_id == message[:user_id]
            if !User.exists?(groupme_id: message[:user_id])
              User.create!(groupme_id: message[:user_id], name: message[:name])
            end

            LikedMessage.create!(user: User.find_by_groupme_id(message[:user_id]), content: message[:text], group_groupme_id: params[:group_id], groupme_id: message[:id])
          end
        end
      end
    end
  end
end
